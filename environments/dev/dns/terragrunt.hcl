include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/dns"
}

dependency "infra" {
  config_path = "../infra"
  
  mock_outputs = {
    aks_kubelet_identity_object_id = "00000000-0000-0000-0000-000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
}

inputs = {
  domain_name                    = local.env_vars.locals.base_domain
  resource_group_name            = "rg-aks-${local.env_vars.locals.environment}"
  aks_kubelet_identity_object_id = dependency.infra.outputs.aks_kubelet_identity_object_id
}
