# Storage Module

## Purpose
Deploys a secure Storage Account with private connectivity and diagnostics.

## Creates
- Storage account with secure defaults (TLS 1.2, no public access, no shared keys).
- Blob containers:
- `func-deploy` for Function Flex package deployment.
- `processed-messages` for processed payload storage.
- Private endpoints for `blob`, `queue`, and `file`.
- Diagnostic settings to Log Analytics.

## Required inputs
- Resource basics: `storage_account_name`, `resource_group_name`, `location`.
- Networking and DNS: `private_endpoint_subnet_id`, `private_dns_zone_id_blob`, `private_dns_zone_id_queue`, `private_dns_zone_id_file`.
- Diagnostics: `log_analytics_workspace_id`, `diagnostic_settings_name`.

## Outputs
- Storage IDs, names, and service URIs.
- Private endpoint IDs.
- Function deployment container URL.
