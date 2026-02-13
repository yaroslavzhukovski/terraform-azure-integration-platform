output "acr_id" {
  description = "The ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}

output "acr_login_server" {
  description = "The login server URL of the Azure Container Registry."
  value       = azurerm_container_registry.this.login_server
}
output "acr_identity_principal_id" {
  description = "The principal ID of the managed identity assigned to the Azure Container Registry."
  value       = azurerm_container_registry.this.identity[0].principal_id
}
