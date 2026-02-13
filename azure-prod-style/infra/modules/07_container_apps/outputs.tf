output "environment_id" {
  value       = azurerm_container_app_environment.this.id
  description = "Container Apps Environment ID."
}

output "environment_default_domain" {
  value       = azurerm_container_app_environment.this.default_domain
  description = "Environment default domain."
}

output "environment_static_ip" {
  value       = azurerm_container_app_environment.this.static_ip_address
  description = "Environment static IP."
}

output "container_app_id" {
  value       = azurerm_container_app.this.id
  description = "Container App ID."
}

output "container_app_fqdn" {
  value       = azurerm_container_app.this.ingress[0].fqdn
  description = "Container App FQDN."
}

output "container_app_principal_id" {
  value       = azurerm_container_app.this.identity[0].principal_id
  description = "Container App managed identity principal ID."
}

