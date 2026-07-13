variable "resource_group_name" {
  type        = string
  description = "Nome do grupo de recursos"
}

variable "location" {
  type        = string
  description = "Localizacao do cluster"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster AKS"
}

variable "dns_prefix" {
  type        = string
  description = "Prefixo DNS do cluster"
}

variable "node_count" {
  type        = number
  description = "Quantidade de nos do default pool"
}

variable "node_vm_size" {
  type        = string
  description = "Tamanho de maquina dos nos"
}

variable "subnet_id" {
  type        = string
  description = "ID da subnet para o cluster"
}
