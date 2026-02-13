output "base_name" {
  value = module.naming.base_name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "tags" {
  value = azurerm_resource_group.rg.tags
}

output "vnet_id" {
  value = module.networking.vnet_id
}
output "subnet_ids" {
  value = module.networking.subnet_ids
}
output "private_dns_zone_ids" {
  value = module.private_dns.zone_ids
}
output "private_dns_zone_names" {
  value = module.private_dns.zone_names
}
output "servicebus_namespace_id" {
  value = module.servicebus.namespace_id
}

output "servicebus_namespace_name" {
  value = module.servicebus.namespace_name
}


output "servicebus_queue_id" {
  value = module.servicebus.queue_id
}

output "servicebus_queue_name" {
  value = module.servicebus.queue_name
}

output "container_app_fqdn" {
  value = module.container_apps.container_app_fqdn
}

output "container_app_principal_id" {
  value = module.container_apps.container_app_principal_id
}

output "containerapps_environment_static_ip" {
  value = module.container_apps.environment_static_ip
}

output "acr_login_server" {
  value = module.container_registry.acr_login_server
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "management_vm_public_ip" {
  description = "Public IP address of the management VM."
  value       = azurerm_public_ip.management_vm.ip_address
}

output "management_vm_admin_username" {
  description = "Admin username for the management VM."
  value       = var.vm_admin_username
}

output "management_vm_private_key_pem" {
  description = "Generated SSH private key for management VM access."
  value       = tls_private_key.vm_admin.private_key_pem
  sensitive   = true
}
