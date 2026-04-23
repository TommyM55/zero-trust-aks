variable "keyvault_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "oidc_issuer_url" {
  type        = string
  description = "OIDC issuer URL from AKS cluster"
}
