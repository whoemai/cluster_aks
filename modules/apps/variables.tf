variable "enable_argocd" {
  type        = bool
  description = "Habilitar a instalacao do Argo CD no cluster"
  default     = true
}

variable "argocd_chart_version" {
  type        = string
  description = "Versao do Helm chart do Argo CD"
  default     = "7.3.1"
}

variable "argocd_helm_values" {
  type        = map(any)
  description = "Valores customizados para o Helm chart do Argo CD"
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}
