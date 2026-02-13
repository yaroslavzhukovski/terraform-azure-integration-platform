output "law_id" {
  description = "Resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "law_workspace_id" {
  description = "Workspace (customer) ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "app_insights_id" {
  description = "Resource ID of Application Insights."
  value       = azurerm_application_insights.this.id
}

output "app_insights_connection_string" {
  value       = azurerm_application_insights.this.connection_string
  description = "Application Insights connection string."
  sensitive   = true
}

output "app_instrumentation_key" {
  description = "Application Insights instrumentation key (legacy, still sometimes used)."
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}
