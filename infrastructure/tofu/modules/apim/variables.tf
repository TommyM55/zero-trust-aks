variable "apim_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "frontend_ip" {
  type        = string
  description = "External IP of the frontend LoadBalancer service"
}
