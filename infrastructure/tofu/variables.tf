variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "zero-trust-rg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Central US"
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
  default     = "zero-trust-aks"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_size" {
  description = "VM size for cluster nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "acr_name" {
  description = "Azure Container Registry name - must be globally unique, alphanumeric only"
  type        = string
  default     = "zerotrustack"
}
