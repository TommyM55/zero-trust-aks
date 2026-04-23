variable "acr_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "kubelet_identity" {
  type        = string
  description = "Object ID of the AKS kubelet identity"
}
