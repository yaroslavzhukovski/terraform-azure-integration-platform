# Naming Module

## Purpose
Generates consistent resource names and common tags for the platform.

## What it produces
- Base naming seed with optional random suffix.
- Standard names for RG, VNet, Storage, Service Bus, Monitoring, Container Apps, Function App, ACR, and App Service API.
- Shared tags map (`env`, `system`, `region`, `iac` plus custom tags).

## Notes
- Region short code is derived from `location`; unknown regions map to `xx`.
- Storage and ACR names are sanitized for Azure naming constraints.

## Key outputs
`base_name`, `tags`, `rg_name`, `vnet_name`, `storage_account_name`, `servicebus_namespace_name`, `law_name`, `appi_name`, `function_app_name`, `acr_name`, `app_service_api_name`.
