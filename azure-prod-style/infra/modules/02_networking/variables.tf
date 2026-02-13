variable "location" {
  type        = string
  description = "Azure region."
}

variable "parent_id" {
  type        = string
  description = "Resource Group ID where the VNet will be deployed (AVM uses parent_id)."
}

variable "vnet_name" {
  type        = string
  description = "Virtual Network name."
}

variable "address_space" {
  type        = list(string)
  description = "VNet address space."
}

variable "subnets" {
  type = any

}

variable "tags" {
  type        = map(string)
  description = "Tags applied to resources."
  default     = {}
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace resource ID for diagnostics. Required when enable_diagnostics=true."
  default     = ""

  validation {
    condition     = var.enable_diagnostics == false || (var.log_analytics_workspace_id != "")
    error_message = "log_analytics_workspace_id must be set when enable_diagnostics is true."
  }
}

variable "enable_diagnostics" {
  type        = bool
  description = "Enable VNet diagnostic settings to Log Analytics."
  default     = true
}

variable "flow_timeout_in_minutes" {
  type        = number
  description = "VNet flow timeout in minutes."
  default     = 30
}

variable "enable_vnet_encryption" {
  type        = bool
  description = "Enable VNet encryption."
  default     = true
}

variable "enable_telemetry" {
  type        = bool
  description = "Enable telemetry for the networking module."
  default     = false
}
