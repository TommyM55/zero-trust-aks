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
  description = "Azure Container Registry name"
  type        = string
  default     = "zerotrustack"
}

variable "keyvault_name" {
  description = "Key Vault name"
  type        = string
  default     = "zerotrust-kv"
}

variable "apim_name" {
  description = "API Management name - must be globally unique"
  type        = string
  default     = "zerotrust-apim"
}

variable "publisher_name" {
  description = "Publisher name for APIM"
  type        = string
  default     = "Zero Trust Project"
}

variable "publisher_email" {
  description = "Publisher email for APIM"
  type        = string
  default     = "tm870522@ohio.edu"
}

variable "frontend_ip" {
  description = "External IP of the frontend service"
  type        = string
  default     = "20.84.201.227"
}
