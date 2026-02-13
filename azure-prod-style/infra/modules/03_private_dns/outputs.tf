output "zone_ids" {
  description = "Map of Private DNS zone IDs by key."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.id }
}

output "zone_names" {
  description = "Map of Private DNS zone names by key."
  value       = { for k, z in azurerm_private_dns_zone.this : k => z.name }
}

