variable "namespace" {
  type        = string
  description = "Namespace do Kubernetes onde o Argo CD sera instalado"
  default     = "argocd"
}

variable "create_namespace" {
  type        = bool
  description = "Define se o namespace deve ser criado pelo Terraform"
  default     = true
}

variable "chart_version" {
  type        = string
  description = "Versao do Helm chart do Argo CD"
  default     = "7.3.1"
}

variable "helm_values" {
  type        = map(any)
  description = "Valores customizados para o Chart do Helm do Argo CD"
  default     = {}
}
