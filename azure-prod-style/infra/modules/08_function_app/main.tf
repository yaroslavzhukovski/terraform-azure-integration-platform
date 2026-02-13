resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "FC1"

  tags = var.tags
}

resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id = azurerm_service_plan.this.id

  https_only                    = true
  public_network_access_enabled = false

  virtual_network_subnet_id = var.subnet_id

  webdeploy_publish_basic_authentication_enabled = false

  identity {
    type = "SystemAssigned"
  }

  # Flex deployment storage (code package container) with Managed Identity
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = var.storage_container_endpoint
  storage_authentication_type = "SystemAssignedIdentity"

  # Runtime for Flex
  runtime_name    = "dotnet-isolated"
  runtime_version = "8.0"

  site_config {
    minimum_tls_version = "1.2"

    application_insights_connection_string = var.app_insights_connection_string
  }

  app_settings = {
    # Service Bus trigger: identity-based (no secrets)
    "AzureWebJobsServiceBus__fullyQualifiedNamespace" = var.servicebus_namespace_fqdn
    "AzureWebJobsServiceBus__credential"              = "managedidentity"

    # Backend target
    "ContainerApp__BaseUrl" = "https://${var.container_app_fqdn}"

    # Storage settings for Functions runtime (required for Flex)
    "AzureWebJobsStorage__credential"      = "managedidentity"
    "AzureWebJobsStorage__blobServiceUri"  = var.storage_blob_service_uri
    "AzureWebJobsStorage__queueServiceUri" = var.storage_queue_service_uri

  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "function_sites" {
  name                = "pe-${var.function_app_name}-sites"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${var.function_app_name}-sites"
    private_connection_resource_id = azurerm_function_app_flex_consumption.this.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id_webapps]
  }

  tags = var.tags
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_function_app_flex_consumption.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.diagnostic_settings_name
  target_resource_id             = azurerm_function_app_flex_consumption.this.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.log_category_types)
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.this.metrics)
    content {
      category = enabled_metric.value
    }
  }
}
