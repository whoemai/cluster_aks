resource "azurerm_dns_zone" "zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "dns_contributor" {
  scope                = azurerm_dns_zone.zone.id
  role_definition_name = "DNS Zone Contributor"
  principal_id         = var.aks_kubelet_identity_object_id
}
