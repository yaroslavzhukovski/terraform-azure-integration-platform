resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = false

  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = false
  default_to_oauth_authentication  = true
  cross_tenant_replication_enabled = false
  local_user_enabled               = false
  sftp_enabled                     = false

  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled = var.enable_versioning

    delete_retention_policy {
      days = var.retention_days_soft_delete
    }

    container_delete_retention_policy {
      days = var.retention_days_soft_delete
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "functions_deploy" {
  name                  = var.functions_deploy_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "processed_messages" {
  name                  = var.processed_messages_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_private_endpoint" "blob" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id_blob]
  }

  tags = var.tags
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_storage_account.this.id
}

resource "azurerm_private_endpoint" "queue" {
  name                = "${var.private_endpoint_name}-queue"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.private_service_connection_name}-queue"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["queue"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id_queue]
  }

  tags = var.tags
}


resource "azurerm_private_endpoint" "file" {
  name                = "${var.private_endpoint_name}-file"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.private_service_connection_name}-file"
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id_file]
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.diagnostic_settings_name
  target_resource_id             = azurerm_storage_account.this.id
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
