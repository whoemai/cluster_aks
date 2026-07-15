variable "resource_group_name" {
  type        = string
  description = "Nome do grupo de recursos"
}

variable "location" {
  type        = string
  description = "Localizacao da rede"
}

variable "vnet_name" {
  type        = string
  description = "Nome da VNet"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Enderecos da VNet"
}

variable "subnet_name" {
  type        = string
  description = "Nome da Subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Prefixo de IPs da Subnet"
}
