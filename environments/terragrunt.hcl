# environments/terragrunt.hcl

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
EOF
}

# Configuração de Backend Remoto (exemplo comentado para Azure)
# remote_state {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = "tfstate-rg"
#     storage_account_name = "tfstate"
#     container_name       = "tfstate"
#     key                  = "${path_relative_to_include()}/terraform.tfstate"
#   }
#   generate = {
#     path      = "backend.tf"
#     if_exists = "overwrite_terragrunt"
#   }
# }
