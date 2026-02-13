# Function App Module

## Purpose
Deploys a Linux Function App Flex Consumption workload with private endpoint and diagnostics.

## Creates
- Service Plan (`FC1`).
- `azurerm_function_app_flex_consumption`.
- Private endpoint for the `sites` subresource.
- Diagnostic settings to Log Analytics.

## Required inputs
- Naming and placement: `service_plan_name`, `function_app_name`, `resource_group_name`, `location`.
- Networking: `subnet_id`, `private_endpoint_subnet_id`, `private_dns_zone_id_webapps`.
- Monitoring: `app_insights_connection_string`, `log_analytics_workspace_id`, `diagnostic_settings_name`.
- Runtime wiring: `servicebus_namespace_fqdn`, `container_app_fqdn`, `storage_container_endpoint`, `storage_blob_service_uri`, `storage_queue_service_uri`.

## Outputs
- `function_app_id`
- `function_app_principal_id`
- `service_plan_id`

## Note
This module does not create deployment slots.
