locals {
  diagnostics_enabled = var.enable_diagnostics
}


module "vnet" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"
  # Intentionally not pinning module version yet (local dev). We'll pin when moving to GitHub.

  name          = var.vnet_name
  location      = var.location
  parent_id     = var.parent_id
  address_space = var.address_space
  tags          = var.tags

  # Avoid forcing public DNS resolvers; rely on Azure-provided DNS to work well with Private DNS zones.
  # (No dns_servers block)

  enable_vm_protection    = false
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  encryption = var.enable_vnet_encryption ? {
    enabled     = true
    enforcement = "AllowUnencrypted"
    } : {
    enabled     = false
    enforcement = "AllowUnencrypted"
  }

  diagnostic_settings = local.diagnostics_enabled ? {
    sendToLogAnalytics = {
      name                           = "sendToLogAnalytics"
      workspace_resource_id          = var.log_analytics_workspace_id
      log_analytics_destination_type = "Dedicated"
    }
  } : {}

  subnets = var.subnets

  enable_telemetry = var.enable_telemetry
}
