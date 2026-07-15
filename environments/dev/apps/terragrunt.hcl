# environments/dev/apps/terragrunt.hcl

include "root" {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/apps"
}

dependency "infra" {
  config_path = "../infra"
  
  mock_outputs = {
    aks_host                   = "https://mock-host"
    aks_client_certificate     = "bW9jaw=="
    aks_client_key             = "bW9jaw=="
    aks_cluster_ca_certificate = "bW9jaw=="
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "providers"]
}

generate "k8s_provider" {
  path      = "k8s_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "kubernetes" {
  host                   = "${dependency.infra.outputs.aks_host}"
  client_certificate     = base64decode("${dependency.infra.outputs.aks_client_certificate}")
  client_key             = base64decode("${dependency.infra.outputs.aks_client_key}")
  cluster_ca_certificate = base64decode("${dependency.infra.outputs.aks_cluster_ca_certificate}")
}

provider "helm" {
  kubernetes {
    host                   = "${dependency.infra.outputs.aks_host}"
    client_certificate     = base64decode("${dependency.infra.outputs.aks_client_certificate}")
    client_key             = base64decode("${dependency.infra.outputs.aks_client_key}")
    cluster_ca_certificate = base64decode("${dependency.infra.outputs.aks_cluster_ca_certificate}")
  }
}
EOF
}

inputs = {
  enable_argocd = true

  argocd_helm_values = {
    server = {
      ingress = {
        enabled = true
        ingressClassName = "nginx"
        hostname = local.env_vars.locals.argocd_domain
        annotations = {
          "cert-manager.io/cluster-issuer" = "letsencrypt-prod" # Ajuste se o issuer for diferente
          "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
        }
        tls = [
          {
            hosts = [local.env_vars.locals.argocd_domain]
            secretName = "argocd-tls"
          }
        ]
      }
    }
  }
}
