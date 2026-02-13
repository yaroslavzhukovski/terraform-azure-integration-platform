variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry instance."

}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the ACR will be created."
}

variable "location" {
  type        = string
  description = "Azure region where the ACR will be deployed."
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Subnet ID for the private endpoint of the ACR."
}

variable "private_dns_zone_id_acr" {
  type        = list(string)
  description = "List of Private DNS Zone IDs to link with the ACR private endpoint."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
