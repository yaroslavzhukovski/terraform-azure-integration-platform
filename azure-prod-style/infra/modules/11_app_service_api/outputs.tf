output "web_app_id" {
  value = azurerm_linux_web_app.this.id
}

output "web_app_name" {
  value = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  value = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  value = azurerm_linux_web_app.this.identity[0].principal_id
}

output "service_plan_id" {
  value = azurerm_service_plan.this.id
}

output "staging_slot_id" {
  description = "Staging slot resource ID."
  value       = try(azurerm_linux_web_app_slot.staging[0].id, null)
}

output "staging_slot_hostname" {
  description = "Staging slot hostname."
  value       = try(azurerm_linux_web_app_slot.staging[0].default_hostname, null)
}


