variable "name_prefix" {
  type        = string
  description = "Base prefix for naming. Lowercase, short. Example: 'yariorders' or 'acme'."
}

variable "location" {
  type        = string
  description = "Azure region (used only for region short code mapping). Example: swedencentral."
}

variable "environment" {
  type        = string
  description = "Environment name. For this project we use single env, e.g. 'main'."
  default     = "main"
}

variable "system" {
  type        = string
  description = "System/workload name. Example: 'orders'."
  default     = "orders"
}

variable "tags" {
  type        = map(string)
  description = "User-provided tags."
  default     = {}
}

variable "random_suffix_length" {
  type        = number
  description = "Length of random suffix appended to names."
  default     = 6
}

variable "enable_random_suffix" {
  type        = bool
  description = "If true, append random suffix to reduce global name collisions (e.g., storage account)."
  default     = true
}
