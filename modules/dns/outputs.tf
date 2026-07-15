output "zone_id" {
  value       = azurerm_dns_zone.zone.id
  description = "The ID of the DNS zone"
}

output "zone_name" {
  value       = azurerm_dns_zone.zone.name
  description = "The name of the DNS zone"
}

output "name_servers" {
  value       = azurerm_dns_zone.zone.name_servers
  description = "The name servers of the DNS zone"
}
