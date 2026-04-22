variable "acr_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "aks_identity" {
  type        = string
  description = "Principal ID of the AKS cluster identity"
}
