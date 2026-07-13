output "resource_group_name" {
  value       = module.resource_group.name
  description = "Nome do Grupo de Recursos"
}

output "kubernetes_cluster_name" {
  value       = module.aks.name
  description = "Nome do cluster AKS"
}

output "connect_command" {
  value       = "az aks get-credentials --resource-group ${module.resource_group.name} --name ${module.aks.name}"
  description = "Comando para conectar o kubectl ao cluster AKS"
}
