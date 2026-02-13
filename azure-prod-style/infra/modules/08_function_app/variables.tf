variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "service_plan_name" {
  type = string
}

variable "function_app_name" {
  type = string
}

# Optional: VNet integration subnet (required for private endpoints reachability)
variable "subnet_id" {
  type    = string
  default = null
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "private_dns_zone_id_webapps" {
  type = string
}

variable "app_insights_connection_string" {
  type = string
}

# Flex deployment package container URL
# Example: https://<storage>.blob.core.windows.net/<container>
variable "storage_container_endpoint" {
  type = string
}

# Identity-based host storage URIs (recommended when using private endpoints + private DNS)
# Examples:
# - https://<storage>.blob.core.windows.net
# - https://<storage>.queue.core.windows.net
variable "storage_blob_service_uri" {
  type = string
}

variable "storage_queue_service_uri" {
  type = string
}

variable "servicebus_namespace_fqdn" {
  type = string
}

variable "container_app_fqdn" {
  type = string
}

# Diagnostics
variable "diagnostic_settings_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}
 
