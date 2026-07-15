output "aks_host" {
  value       = module.aks.host
  sensitive   = true
  description = "AKS host endpoint"
}

output "aks_client_certificate" {
  value       = module.aks.client_certificate
  sensitive   = true
  description = "AKS client certificate"
}

output "aks_client_key" {
  value       = module.aks.client_key
  sensitive   = true
  description = "AKS client key"
}

output "aks_cluster_ca_certificate" {
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
  description = "AKS cluster CA certificate"
}
