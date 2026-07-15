module "argocd" {
  count  = var.enable_argocd ? 1 : 0
  source = "./modules/argocd"

  chart_version = var.argocd_chart_version
  helm_values   = var.argocd_helm_values
}
