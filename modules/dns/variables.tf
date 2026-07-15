variable "domain_name" {
  type        = string
  description = "The domain name for the DNS zone"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the DNS zone will be created"
}

variable "aks_kubelet_identity_object_id" {
  type        = string
  description = "The Object ID of the AKS kubelet identity to grant DNS Zone Contributor role"
}
