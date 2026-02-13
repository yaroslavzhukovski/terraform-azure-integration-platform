output "namespace_id" {
  value       = azurerm_servicebus_namespace.this.id
  description = "Service Bus namespace resource ID."
}

output "namespace_name" {
  value       = azurerm_servicebus_namespace.this.name
  description = "Service Bus namespace name."
}

output "servicebus_namespace_fqdn" {
  value       = "${azurerm_servicebus_namespace.this.name}.servicebus.windows.net"
  description = "Service Bus Namespace FQDN."
}

output "queue_id" {
  value       = azurerm_servicebus_queue.this.id
  description = "Service Bus queue resource ID."
}

output "queue_name" {
  value       = azurerm_servicebus_queue.this.name
  description = "Service Bus queue name."
}

output "diagnostic_setting_id" {
  value       = azurerm_monitor_diagnostic_setting.this.id
  description = "Diagnostic setting ID."
}

