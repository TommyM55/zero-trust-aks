output "keyvault_name" {
  value = azurerm_key_vault.main.name
}

output "keyvault_uri" {
  value = azurerm_key_vault.main.vault_uri
}

output "products_client_id" {
  value = azurerm_user_assigned_identity.products.client_id
}

output "orders_client_id" {
  value = azurerm_user_assigned_identity.orders.client_id
}

output "frontend_client_id" {
  value = azurerm_user_assigned_identity.frontend.client_id
}
