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

output "keyvault_name" {
  value = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  value = module.keyvault.keyvault_uri
}

output "products_client_id" {
  value = module.keyvault.products_client_id
}

output "orders_client_id" {
  value = module.keyvault.orders_client_id
}

output "frontend_client_id" {
  value = module.keyvault.frontend_client_id
}

output "apim_gateway_url" {
  value = module.apim.apim_gateway_url
}
