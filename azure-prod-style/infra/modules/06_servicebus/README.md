# Service Bus Module

## Purpose
Deploys a Service Bus namespace and queue with diagnostics.

## Creates
- Service Bus namespace (`local_auth_enabled = false`, minimum TLS 1.2).
- Service Bus queue with configurable delivery, TTL, and duplicate detection behavior.
- Diagnostic settings to Log Analytics.

## Required inputs
- `resource_group_name`
- `location`
- `namespace_name`
- `queue_name`
- `log_analytics_workspace_id`
- `diagnostic_settings_name`

## Outputs
- `namespace_id`
- `namespace_name`
- `servicebus_namespace_fqdn`
- `queue_id`
- `queue_name`
- `diagnostic_setting_id`

## Note
This module does not create private endpoints or private DNS links.
