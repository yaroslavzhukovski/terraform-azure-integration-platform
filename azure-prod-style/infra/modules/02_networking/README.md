# Networking Module

## Purpose
Deploys a Virtual Network through Azure Verified Module (AVM) with subnets and optional diagnostics.

## Creates
- VNet and subnets from the provided `subnets` map.
- Optional diagnostic settings to Log Analytics.

## Required inputs
- `location`
- `parent_id` (resource group ID)
- `vnet_name`
- `address_space`
- `subnets`

## Outputs
- `vnet_id`
- `vnet_name`
- `subnet_ids`
- `subnets`

## Notes
- Uses `Azure/avm-res-network-virtualnetwork/azurerm`.
- `log_analytics_workspace_id` is required when diagnostics are enabled.
