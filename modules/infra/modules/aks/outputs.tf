output "id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "ID do cluster AKS"
}

output "name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Nome do cluster AKS"
}

output "kube_config_raw" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
  description = "kubeconfig"
}

output "host" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].host
  sensitive   = true
  description = "AKS host endpoint"
}

output "client_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
  sensitive   = true
  description = "AKS client certificate"
}

output "client_key" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
  sensitive   = true
  description = "AKS client key"
}

output "cluster_ca_certificate" {
  value       = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  sensitive   = true
  description = "AKS cluster CA certificate"
}
