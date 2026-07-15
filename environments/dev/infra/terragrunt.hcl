# environments/dev/infra/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/infra"
}

inputs = {
  location            = local.env_vars.locals.location
  resource_group_name = "rg-aks-${local.env_vars.locals.environment}"
  cluster_name        = local.env_vars.locals.cluster_name
  node_count          = local.env_vars.locals.node_count
  
  # Outras variáves da infraestrutura
  vnet_name          = "vnet-aks-${local.env_vars.locals.environment}"
  subnet_name        = "subnet-aks-${local.env_vars.locals.environment}"
  dns_prefix         = "aks-${local.env_vars.locals.environment}"
  enable_cilium      = local.env_vars.locals.enable_cilium
  node_vm_size       = local.env_vars.locals.vm_size
}
