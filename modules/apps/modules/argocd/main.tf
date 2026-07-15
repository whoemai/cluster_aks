resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = var.create_namespace ? kubernetes_namespace.argocd[0].metadata[0].name : var.namespace

  values = length(keys(var.helm_values)) > 0 ? [yamlencode(var.helm_values)] : []
}

resource "null_resource" "argocd_cleanup" {
  triggers = {
    namespace = var.create_namespace ? kubernetes_namespace.argocd[0].metadata[0].name : var.namespace
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["powershell", "-Command"]
    command     = <<EOT
      $ErrorActionPreference = 'SilentlyContinue'
      $ns = "${self.triggers.namespace}"
      $apps = kubectl get applications.argoproj.io,appprojects.argoproj.io -n $ns -o name 2>$null
      if ($apps) {
        $apps | ForEach-Object {
          kubectl patch $_ -n $ns --type="merge" -p '{\"metadata\":{\"finalizers\":null}}'
        }
      }
    EOT
  }

  depends_on = [helm_release.argocd]
}

resource "helm_release" "argocd_apps" {
  name       = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-apps"
  version    = "2.0.0"
  namespace  = var.create_namespace ? kubernetes_namespace.argocd[0].metadata[0].name : var.namespace

  values = [
    <<-EOT
    applications:
      root-addons:
        namespace: argocd
        project: default
        source:
          repoURL: 'https://github.com/whoemai/git_addons.git'
          targetRevision: HEAD
          path: apps
        destination:
          server: 'https://kubernetes.default.svc'
          namespace: argocd
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
          syncOptions:
            - CreateNamespace=true
        finalizers:
          - resources-finalizer.argocd.argoproj.io
    EOT
  ]

  depends_on = [helm_release.argocd]
}
