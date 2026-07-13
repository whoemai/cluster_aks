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
