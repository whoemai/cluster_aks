output "name" {
  value       = azurerm_resource_group.rg.name
  description = "Nome do grupo de recursos"
}

output "location" {
  value       = azurerm_resource_group.rg.location
  description = "Localizacao do grupo de recursos"
}
