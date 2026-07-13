module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  subnet_name         = var.subnet_name
  subnet_prefixes     = var.subnet_prefixes
}

module "aks" {
  source              = "./modules/aks"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  node_vm_size        = var.node_vm_size
  subnet_id           = module.network.subnet_id
}

module "argocd" {
  count  = var.enable_argocd ? 1 : 0
  source = "./modules/argocd"

  chart_version = var.argocd_chart_version
  helm_values   = var.argocd_helm_values
}
