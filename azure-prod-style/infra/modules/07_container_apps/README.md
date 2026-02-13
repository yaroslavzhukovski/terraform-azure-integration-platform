# Container Apps Module

## Purpose
Deploys a Container Apps environment and a Container App using identity-based pull from ACR.

## Creates
- Container Apps environment integrated to the provided subnet.
- Environment with internal load balancer and public network access disabled.
- Container App with managed identity configuration and registry block for ACR pull.
- Ingress on the app (`external_enabled = true`).

## Required inputs
- Environment: `container_app_environment_name`, `infrastructure_subnet_id`, `log_analytics_workspace_id`.
- App: `container_app_name`, `container_image`, `target_port`.
- Registry: `acr_login_server`, `registry_identity_id`.

## Outputs
- `environment_id`
- `environment_default_domain`
- `environment_static_ip`
- `container_app_id`
- `container_app_fqdn`
- `container_app_principal_id`
