variable "resource_group_name" {
  type        = string
  description = "Nome do grupo de recursos no Azure"
  default     = "terraform-aks-rg"
}

variable "location" {
  type        = string
  description = "Regiao do Azure onde os recursos serao criados"
  default     = "eastus"
}

variable "vnet_name" {
  type        = string
  description = "Nome da Virtual Network (VNet)"
  default     = "aks-vnet"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Endereco de rede da VNet"
  default     = ["10.0.0.0/8"]
}

variable "subnet_name" {
  type        = string
  description = "Nome da Subnet do AKS"
  default     = "aks-subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Prefixo de rede da Subnet"
  default     = ["10.240.0.0/16"]
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster AKS"
  default     = "terraform-aks-cluster"
}

variable "dns_prefix" {
  type        = string
  description = "Prefixo DNS para o cluster AKS"
  default     = "tf-aks-cluster"
}

variable "node_count" {
  type        = number
  description = "Numero de nos no node pool padrao"
  default     = 1
}

variable "node_vm_size" {
  type        = string
  description = "Tamanho da VM para os nos do cluster"
  default     = "Standard_B2s"
}

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

variable "enable_cilium" {
  type        = bool
  description = "Define se o cluster vai utilizar o Cilium (cluster robusto) ou kube-proxy (cluster simples)"
  default     = false
}
