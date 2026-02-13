# Container Registry Module

## Purpose
Deploys a private Azure Container Registry (Premium) with private endpoint integration.

## Creates
- Azure Container Registry with system-assigned identity.
- Private endpoint to the `registry` subresource.
- Private DNS zone group association for provided DNS zone IDs.

## Required inputs
- `acr_name`
- `resource_group_name`
- `location`
- `private_endpoints_subnet_id`
- `private_dns_zone_id_acr`

## Outputs
- `acr_id`
- `acr_login_server`
- `acr_identity_principal_id`
