variable "storage_account_name" {
  description = "Storage Account name."
  type        = string

}
variable "location" {
  description = "Azure region where resources will be created."
  type        = string

}
variable "resource_group_name" {
  description = "Resource group name where resources will be created."
  type        = string
}
variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
variable "account_tier" {
  description = "Storage Account tier."
  type        = string
  default     = "Standard"
}
variable "replication_type" {
  description = "Storage Account replication type."
  type        = string
  default     = "LRS"
}
variable "enable_versioning" {
  description = "Enable blob versioning."
  type        = bool
  default     = true
}
variable "retention_days_soft_delete" {
  description = "Number of days to retain soft deleted blobs."
  type        = number
  default     = 7
}
variable "functions_deploy_container_name" {
  type        = string
  description = "Blob container used by Azure Functions Flex Consumption for code deployments."
  default     = "func-deploy"
}

variable "processed_messages_container_name" {
  type        = string
  description = "Blob container used by container app to store processed messages."
  default     = "processed-messages"
}

variable "private_endpoint_name" {
  description = "Private Endpoint name."
  type        = string
}
variable "private_endpoint_subnet_id" {
  description = "Subnet ID for the Private Endpoint."
  type        = string
}
variable "private_service_connection_name" {
  description = "Name for the Private Service Connection."
  type        = string
}
variable "private_dns_zone_id_blob" {
  description = "Private DNS Zone ID for Blob service."
  type        = string
}

variable "private_dns_zone_id_queue" {
  type        = string
  description = "Private DNS Zone ID for queue (privatelink.queue.core.windows.net)."
}

variable "private_dns_zone_id_file" {
  type        = string
  description = "Private DNS Zone ID for file (privatelink.file.core.windows.net)."
}


variable "diagnostic_settings_name" {

  description = "Name for the Diagnostic Settings."
  type        = string

}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics."
  type        = string
}
