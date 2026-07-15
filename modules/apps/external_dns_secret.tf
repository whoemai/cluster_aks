data "azurerm_client_config" "current" {}

resource "kubernetes_secret" "azure_config_file" {
  metadata {
    name      = "azure-config-file"
    namespace = "external-dns"
  }

  data = {
    "azure.json" = jsonencode({
      tenantId                    = data.azurerm_client_config.current.tenant_id
      subscriptionId              = data.azurerm_client_config.current.subscription_id
      resourceGroup               = var.resource_group_name
      useManagedIdentityExtension = true
    })
  }
}