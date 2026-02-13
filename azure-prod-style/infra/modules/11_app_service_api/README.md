# App Service API Module

## Purpose
Deploys a Linux App Service API with optional staging slot, autoscale, and diagnostics.

## Creates
- Linux App Service Plan.
- Linux Web App with system-assigned identity.
- Optional `staging` deployment slot.
- Optional autoscale setting on the App Service Plan.
- Diagnostic settings for app and slot (when enabled).

## Required inputs
- Base: `name`, `location`, `resource_group_name`.
- Monitoring: `log_analytics_workspace_id`, `application_insights_connection_string`.
- Messaging: `servicebus_fqdn`, `servicebus_queue_name`.

## Outputs
- `web_app_id`
- `web_app_name`
- `default_hostname`
- `principal_id`
- `service_plan_id`
- `staging_slot_id` (nullable)
- `staging_slot_hostname` (nullable)

## Naming note
This module prefixes the input name with `asp-` and `app-` internally.
