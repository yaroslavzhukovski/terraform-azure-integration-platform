variable "name" {
  description = "Short unique name component used in resource names."
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "sku_name" {
  description = "App Service Plan SKU (cost-friendly default). Examples: B1, S1."
  type        = string
  default     = "S1"
}

variable "dotnet_version" {
  description = "Built-in .NET stack version."
  type        = string
  default     = "8.0"
}

variable "always_on" {
  description = "Keep false for lab/cost. Requires at least Basic."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for Diagnostic Settings."
  type        = string
}

variable "application_insights_connection_string" {
  description = "Application Insights connection string."
  type        = string
  sensitive   = true
}

variable "servicebus_fqdn" {
  description = "Service Bus namespace FQDN, e.g. sb-xxx.servicebus.windows.net."
  type        = string
}

variable "servicebus_queue_name" {
  description = "Service Bus queue name."
  type        = string
}

variable "enable_slot" {
  description = "Enable a staging deployment slot."
  type        = bool
  default     = true
}

variable "enable_autoscale" {
  description = "Enable autoscale for the App Service Plan."
  type        = bool
  default     = true
}

variable "autoscale_min" {
  description = "Autoscale minimum instance count."
  type        = number
  default     = 1
}

variable "autoscale_default" {
  description = "Autoscale default instance count."
  type        = number
  default     = 1
}

variable "autoscale_max" {
  description = "Autoscale maximum instance count."
  type        = number
  default     = 2
}
