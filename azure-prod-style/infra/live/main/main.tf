module "naming" {
  source = "../../modules/01_naming"

  name_prefix = var.name_prefix
  location    = var.location
  environment = var.environment
  system      = var.system
  tags        = var.tags

  enable_random_suffix = true
  random_suffix_length = 6
}

resource "azurerm_resource_group" "rg" {
  name     = module.naming.rg_name
  location = var.location
  tags     = module.naming.tags
}

resource "azurerm_user_assigned_identity" "container_registry_pull" {
  name                = "uami-${module.naming.base_name}-ca-pull"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.naming.tags
}

module "networking" {
  source = "../../modules/02_networking"

  location                   = var.location
  parent_id                  = azurerm_resource_group.rg.id
  vnet_name                  = module.naming.vnet_name
  address_space              = var.vnet_address_space
  subnets                    = local.subnets
  log_analytics_workspace_id = module.monitoring.law_id

  tags = module.naming.tags
}

module "private_dns" {
  source = "../../modules/03_private_dns"

  resource_group_name = azurerm_resource_group.rg.name
  vnet_id             = module.networking.vnet_id
  zones               = var.private_dns_zones

  tags = module.naming.tags

}

module "monitoring" {
  source = "../../modules/04_monitoring"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  law_name          = module.naming.law_name
  app_insights_name = module.naming.appi_name

  retention_in_days = var.law_retention_in_days
  law_sku           = var.law_sku

  tags = module.naming.tags
}

module "storage" {
  source = "../../modules/05_storage"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = module.naming.tags

  storage_account_name = module.naming.storage_account_name

  private_endpoint_name           = module.naming.private_endpoint_blob_name
  private_service_connection_name = "${module.naming.base_name}-psc-blob"

  private_endpoint_subnet_id = module.networking.subnet_ids["snet-private-endpoints"]
  private_dns_zone_id_blob   = module.private_dns.zone_ids["blob"]
  private_dns_zone_id_queue  = module.private_dns.zone_ids["queue"]
  private_dns_zone_id_file   = module.private_dns.zone_ids["file"]


  log_analytics_workspace_id = module.monitoring.law_id
  diagnostic_settings_name   = "${module.naming.base_name}-diag-stg"

  enable_versioning          = var.enable_storage_versioning
  retention_days_soft_delete = var.storage_retention_days_soft_delete
  replication_type           = var.storage_replication_type
}

module "servicebus" {
  source = "../../modules/06_servicebus"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  namespace_name      = module.naming.servicebus_namespace_name
  queue_name          = var.servicebus_queue_name

  sku = var.servicebus_sku

  log_analytics_workspace_id = module.monitoring.law_id
  diagnostic_settings_name   = var.servicebus_diagnostic_settings_name

  partitioning_enabled                    = var.servicebus_partitioning_enabled
  max_delivery_count                      = var.servicebus_max_delivery_count
  lock_duration                           = var.servicebus_lock_duration
  default_message_ttl                     = var.servicebus_default_message_ttl
  dead_lettering_on_message_expiration    = var.servicebus_dead_letter_on_expiration
  requires_duplicate_detection            = var.servicebus_requires_duplicate_detection
  duplicate_detection_history_time_window = var.servicebus_duplicate_window

  tags = module.naming.tags
}


module "container_apps" {
  source = "../../modules/07_container_apps"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  container_app_environment_name = module.naming.containerapps_environment_name
  container_app_name             = module.naming.container_app_name

  infrastructure_subnet_id   = module.networking.subnet_ids["snet-containerapps"]
  log_analytics_workspace_id = module.monitoring.law_id

  container_image = var.container_app_image
  target_port     = var.container_app_target_port

  acr_login_server     = var.container_app_acr_login_server
  registry_identity_id = azurerm_user_assigned_identity.container_registry_pull.id

  container_env = {
    STORAGE_ACCOUNT_NAME   = module.storage.storage_account_name
    STORAGE_CONTAINER_NAME = module.storage.processed_messages_container_name
  }

  tags = module.naming.tags

  # Optional overrides:
  # container_image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
  # target_port     = 80
  # min_replicas    = 0
  # max_replicas    = 1

  depends_on = [azurerm_role_assignment.container_registry_pull_uami]
}

# Internal Container Apps environments require a private DNS zone for their
# default domain so VMs in the VNet can resolve app FQDNs.
resource "azurerm_private_dns_zone" "containerapps_internal" {
  name                = module.container_apps.environment_default_domain
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.naming.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "containerapps_internal" {
  name                  = "link-containerapps-internal"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.containerapps_internal.name
  virtual_network_id    = module.networking.vnet_id
  registration_enabled  = false
  tags                  = module.naming.tags
}

resource "azurerm_private_dns_a_record" "containerapps_internal_wildcard" {
  name                = "*"
  zone_name           = azurerm_private_dns_zone.containerapps_internal.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [module.container_apps.environment_static_ip]
}

resource "azurerm_private_dns_a_record" "containerapps_internal_apex" {
  name                = "@"
  zone_name           = azurerm_private_dns_zone.containerapps_internal.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [module.container_apps.environment_static_ip]
}

module "function_app" {
  source = "../../modules/08_function_app"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  service_plan_name = module.naming.asp_name
  function_app_name = module.naming.function_app_name

  subnet_id                   = module.networking.subnet_ids["snet-function-integration"]
  private_endpoint_subnet_id  = module.networking.subnet_ids["snet-private-endpoints"]
  private_dns_zone_id_webapps = module.private_dns.zone_ids["webapps"]

  app_insights_connection_string = module.monitoring.app_insights_connection_string

  servicebus_namespace_fqdn = module.servicebus.servicebus_namespace_fqdn
  container_app_fqdn        = module.container_apps.container_app_fqdn

  # Deployment container (Blob) for Flex packages
  storage_container_endpoint = module.storage.functions_deployment_container_url

  # Identity-based host storage endpoints (no secrets)
  storage_blob_service_uri  = module.storage.blob_service_uri
  storage_queue_service_uri = module.storage.queue_service_uri

  diagnostic_settings_name   = "${module.naming.base_name}-diag-func"
  log_analytics_workspace_id = module.monitoring.law_id

  tags = module.naming.tags
}

module "rbac" {
  source = "../../modules/09_role_assignments"

  role_assignments = {
    function_sb_receiver = {
      scope                = module.servicebus.queue_id
      role_definition_name = "Azure Service Bus Data Receiver"
      principal_id         = module.function_app.function_app_principal_id
    }

    function_storage_blob = {
      scope                = module.storage.storage_account_id
      role_definition_name = "Storage Blob Data Contributor"
      principal_id         = module.function_app.function_app_principal_id
    }

    function_storage_queue = {
      scope                = module.storage.storage_account_id
      role_definition_name = "Storage Queue Data Contributor"
      principal_id         = module.function_app.function_app_principal_id
    }

    #function_storage_file = {
    #  scope                = module.storage.storage_account_id
    #  role_definition_name = "Storage File Data SMB Share Contributor"
    #  principal_id         = module.function_app.function_app_principal_id
    #}


    container_storage_blob = {
      scope                = module.storage.storage_account_id
      role_definition_name = "Storage Blob Data Contributor"
      principal_id         = module.container_apps.container_app_principal_id
    }
    app_service_api_servicebus = {
      scope                = module.servicebus.queue_id
      role_definition_name = "Azure Service Bus Data Sender"
      principal_id         = module.app_service_api.principal_id
    }
  }
}

module "container_registry" {
  source = "../../modules/10_container_registry"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  acr_name = module.naming.acr_name

  private_endpoints_subnet_id = module.networking.subnet_ids["snet-private-endpoints"]
  private_dns_zone_id_acr     = [module.private_dns.zone_ids["acr"]]

  tags = module.naming.tags

}

resource "azurerm_role_assignment" "container_registry_pull_uami" {
  scope                = module.container_registry.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_registry_pull.principal_id
}

module "app_service_api" {
  source = "../../modules/11_app_service_api"

  name                = module.naming.app_service_api_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.naming.tags

  sku_name       = var.app_service_api_sku_name
  dotnet_version = var.app_service_api_dotnet_version
  always_on      = var.app_service_api_always_on

  log_analytics_workspace_id             = module.monitoring.law_id
  application_insights_connection_string = module.monitoring.app_insights_connection_string
  servicebus_fqdn                        = module.servicebus.servicebus_namespace_fqdn
  servicebus_queue_name                  = var.servicebus_queue_name

  enable_slot       = var.app_service_api_enable_slot
  enable_autoscale  = var.app_service_api_enable_autoscale
  autoscale_min     = var.app_service_api_autoscale_min
  autoscale_default = var.app_service_api_autoscale_default
  autoscale_max     = var.app_service_api_autoscale_max
}





#Test vm for connectivity and management access to the environment. In production, this would typically be a jumpbox/bastion host with hardened security and monitoring

resource "tls_private_key" "vm_admin" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_network_security_group" "management" {
  name                = "nsg-${module.naming.base_name}-management"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.naming.tags
}

resource "azurerm_network_security_rule" "management_ssh_inbound" {
  name                        = "Allow-SSH-Inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = length(var.vm_ssh_allowed_cidrs) == 1 ? var.vm_ssh_allowed_cidrs[0] : null
  source_address_prefixes     = length(var.vm_ssh_allowed_cidrs) > 1 ? var.vm_ssh_allowed_cidrs : null
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.management.name
}

resource "azurerm_public_ip" "management_vm" {
  name                = "pip-${module.naming.base_name}-management-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.naming.tags
}

resource "azurerm_network_interface" "management_vm" {
  name                = "nic-${module.naming.base_name}-management-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = module.naming.tags

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = module.networking.subnet_ids["snet-management"]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management_vm.id
  }
}

resource "azurerm_linux_virtual_machine" "management_vm" {
  name                            = "vm-${module.naming.base_name}-management"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.vm_admin_username
  network_interface_ids           = [azurerm_network_interface.management_vm.id]
  disable_password_authentication = true
  tags                            = module.naming.tags

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.vm_admin.public_key_openssh
  }

  os_disk {
    name                 = "osdisk-${module.naming.base_name}-management"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
