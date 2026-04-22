output "resource_group_name" {
  value = module.networking.resource_group_name
}

output "cluster_name" {
  value = module.aks.cluster_name
}

output "cluster_identity" {
  value = module.aks.cluster_identity
}

output "acr_login_server" {
  value = module.acr.acr_login_server
}
