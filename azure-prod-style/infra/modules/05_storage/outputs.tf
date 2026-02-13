output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_access_key" {
  description = "Primary access key for the Storage Account."
  sensitive   = true
  value       = azurerm_storage_account.this.primary_access_key
}

output "primary_connection_string" {
  description = "Primary connection string for the Storage Account."
  sensitive   = true
  value       = azurerm_storage_account.this.primary_connection_string
}

output "primary_blob_endpoint" {
  description = "Primary Blob endpoint (URL)."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "private_endpoint_queue_id" {
  value       = azurerm_private_endpoint.queue.id
  description = "Private Endpoint ID for queue."
}

output "private_endpoint_file_id" {
  value       = azurerm_private_endpoint.file.id
  description = "Private Endpoint ID for file."
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint for Blob."
  value       = azurerm_private_endpoint.blob.id
}

output "private_endpoint_private_ip" {
  description = "Private IP address assigned to the Private Endpoint NIC."
  value       = azurerm_private_endpoint.blob.private_service_connection[0].private_ip_address
}

output "blob_service_uri" {
  value = "https://${azurerm_storage_account.this.name}.blob.core.windows.net"
}

output "queue_service_uri" {
  value = "https://${azurerm_storage_account.this.name}.queue.core.windows.net"
}

output "functions_deployment_container_url" {
  value = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.functions_deploy.name}"
}

output "processed_messages_container_name" {
  description = "Blob container name for processed messages written by Container App."
  value       = azurerm_storage_container.processed_messages.name
}
