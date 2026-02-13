output "vnet_id" {
  value       = module.vnet.resource_id
  description = "Virtual Network resource ID."
}

output "vnet_name" {
  value       = module.vnet.name
  description = "Virtual Network name."
}

output "subnet_ids" {
  value       = { for k, s in module.vnet.subnets : k => s.resource_id }
  description = "Map of subnet IDs by subnet key."
}

output "subnets" {
  value       = module.vnet.subnets
  description = "Full subnet output objects from the AVM module."
}

