resource "azurerm_servicebus_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name

  local_auth_enabled  = false
  minimum_tls_version = "1.2"


  sku = var.sku

  tags = var.tags
}

resource "azurerm_servicebus_queue" "this" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.this.id

  partitioning_enabled                 = var.partitioning_enabled
  max_delivery_count                   = var.max_delivery_count
  lock_duration                        = var.lock_duration
  default_message_ttl                  = var.default_message_ttl
  dead_lettering_on_message_expiration = var.dead_lettering_on_message_expiration

  requires_duplicate_detection            = var.requires_duplicate_detection
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
}

data "azurerm_monitor_diagnostic_categories" "this" {
  resource_id = azurerm_servicebus_namespace.this.id
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                           = var.diagnostic_settings_name
  target_resource_id             = azurerm_servicebus_namespace.this.id
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
