# environments/dev/env.hcl

locals {
  environment = "dev"
  location    = "eastus"
  
  # Variáveis globais do cluster
  cluster_name = "terragrunt-aks-dev"
  node_count   = 2
  
  # Variáveis adicionais (você pode alterar livremente)
  enable_cilium = false
  vm_size       = "Standard_B2s"
  
  # Dominios
  base_domain   = "khalifa.com"
  argocd_domain = "argocd.${local.base_domain}"
}
