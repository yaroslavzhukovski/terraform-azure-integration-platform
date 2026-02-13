variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "namespace_name" {
  type        = string
  description = "Service Bus namespace name."
}

variable "queue_name" {
  type        = string
  description = "Service Bus queue name."
}

variable "sku" {
  type        = string
  description = "Service Bus namespace SKU."
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "sku must be one of: Basic, Standard, Premium."
  }
}

variable "partitioning_enabled" {
  type        = bool
  description = "Enable partitioning on queue."
  default     = true
}

variable "max_delivery_count" {
  type        = number
  description = "Max delivery attempts before DLQ."
  default     = 10
}

variable "lock_duration" {
  type        = string
  description = "Message lock duration (ISO8601, e.g. PT1M)."
  default     = "PT1M"
}

variable "default_message_ttl" {
  type        = string
  description = "Default message TTL (ISO8601 duration format, e.g. P7D)."
  default     = "P7D"
}

variable "dead_lettering_on_message_expiration" {
  type        = bool
  description = "Send expired messages to DLQ."
  default     = true
}

variable "requires_duplicate_detection" {
  type        = bool
  description = "Enable duplicate detection."
  default     = true
}

variable "duplicate_detection_history_time_window" {
  type        = string
  description = "Duplicate detection history window (ISO8601, e.g. PT10M)."
  default     = "PT10M"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID for diagnostics."
}

variable "diagnostic_settings_name" {
  type        = string
  description = "Diagnostic setting name."
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}

