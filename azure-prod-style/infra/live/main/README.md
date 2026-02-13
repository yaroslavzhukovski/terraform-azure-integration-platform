# Live Stack: `main`

## What This Is
This folder contains the Terraform live deployment for the `main` environment.
It composes reusable modules from `infra/modules` into one working Azure stack.

## What It Deploys
- Resource Group with standardized naming and tags.
- Virtual Network and workload subnets.
- Private DNS zones and VNet links.
- Monitoring baseline: Log Analytics + Application Insights.
- Storage Account with private endpoints and diagnostics.
- Service Bus namespace + queue + diagnostics.
- Container Apps environment and message processor app.
- Function App Flex Consumption with managed identity integration.
- App Service API (Linux) with optional slot/autoscale.
- RBAC role assignments between identities and resources.
- Container Registry with private endpoint.
- Management VM (SSH-based) for controlled access/testing.

## How It Works
1. Naming is generated first (`01_naming`) and reused across all modules.
2. Networking and private DNS are created before workload services.
3. Monitoring is provisioned early so diagnostics can attach immediately.
4. Storage, Service Bus, Container Apps, Function App, ACR, and App Service are deployed.
5. Managed identities and RBAC grants are applied for runtime access.
6. Live-only glue resources handle internal Container Apps DNS and management VM access.

## Inputs
Main configuration is controlled by:
- `variables.tf` (all stack inputs)
- `terraform.tfvars` (environment-specific values)
- `terraform.tfvars.example` (starting template)

Most important variables:
- Naming/placement: `location`, `name_prefix`, `environment`, `system`
- Network: `vnet_address_space`, `subnet_cidrs`, `private_dns_zones`
- Workloads: `container_app_image`, `container_app_acr_login_server`, `servicebus_*`, `storage_*`, `app_service_api_*`
- Access: `vm_ssh_allowed_cidrs`, `vm_admin_username`, `vm_size`

## Run This Stack
From this directory (`infra/live/main`):

```bash
terraform init
terraform validate
terraform plan -out tfplan
terraform apply tfplan
```

## Useful Outputs
After apply, key outputs include:
- `resource_group_name`
- `vnet_id`, `subnet_ids`
- `servicebus_namespace_name`, `servicebus_queue_name`
- `container_app_fqdn`
- `storage_account_name`
- `acr_login_server`
- `management_vm_public_ip`

## Operational Notes
- `.terraform/`, `tfplan`, and `plan.txt` are generated runtime artifacts.
- `terraform.tfstate` in this folder is local state; protect it because it contains sensitive metadata.
- `management_vm_private_key_pem` output is sensitive and must be handled securely.
