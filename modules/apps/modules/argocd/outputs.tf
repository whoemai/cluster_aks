output "namespace" {
  value       = var.namespace
  description = "Namespace onde o Argo CD foi instalado"
}

output "helm_release_name" {
  value       = helm_release.argocd.name
  description = "Nome da release do Helm para o Argo CD"
}

output "helm_release_status" {
  value       = helm_release.argocd.status
  description = "Status da release do Helm do Argo CD"
}
