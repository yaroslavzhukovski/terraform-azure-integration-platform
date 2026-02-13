variable "resource_group_name" {
  type        = string
  description = "Resource group name where Private DNS zones will be created."
}

variable "vnet_id" {
  type        = string
  description = "VNet ID to link Private DNS zones to."
}

variable "zones" {
  type        = map(string)
  description = "Map of zone keys to Private DNS zone domain names. Example: { blob = \"privatelink.blob.core.windows.net\" }"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to Private DNS zone resources."
  default     = {}
}

