# Private DNS Module

## Purpose
Creates Azure Private DNS zones and links them to a VNet.

## Creates
- `azurerm_private_dns_zone` for each entry in `zones`.
- `azurerm_private_dns_zone_virtual_network_link` to the provided VNet.

## Required inputs
- `resource_group_name`
- `vnet_id`
- `zones`

## Outputs
- `zone_ids`
- `zone_names`
