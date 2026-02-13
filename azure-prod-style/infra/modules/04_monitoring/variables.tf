variable "law_name" {
  description = "Log Analytics Workspace name."
  type        = string
}

variable "app_insights_name" {
  description = "Application Insights name."
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

variable "law_sku" {
  description = "Log Analytics Workspace SKU."
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Log Analytics retention in days."
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}
