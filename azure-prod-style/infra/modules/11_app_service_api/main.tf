resource "azurerm_service_plan" "this" {
  name                = "asp-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = "app-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id

  https_only                 = true
  tags                       = var.tags
  client_certificate_enabled = false
  client_certificate_mode    = "Optional"



  identity {
    type = "SystemAssigned"
  }

  # Disable legacy publish mechanisms for better security posture
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    # Keep Always On enabled for production-like behavior (requires Standard+)
    always_on                         = var.always_on
    minimum_tls_version               = "1.2"
    http2_enabled                     = true
    ftps_state                        = "Disabled"
    scm_ip_restriction_default_action = "Allow"

    # Recommended baseline hardening
    remote_debugging_enabled = false
    websockets_enabled       = false

    application_stack {
      dotnet_version = var.dotnet_version
    }
  }

  app_settings = {
    # Application Insights instrumentation
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.application_insights_connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "SERVICEBUS_FQDN"                            = var.servicebus_fqdn
    "SERVICEBUS_QUEUE_NAME"                      = var.servicebus_queue_name

    # Helpful app metadata (can be used in logs)
    "APP_COMPONENT"   = "appservice-api"
    "APP_ENVIRONMENT" = "production"
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  count = var.enable_slot ? 1 : 0

  name           = "staging"
  app_service_id = azurerm_linux_web_app.this.id
  tags           = var.tags

  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false
  client_certificate_enabled                     = false
  client_certificate_mode                        = "Optional"

  # Slot identity is separate; enable if you want to test MI-based access from slot
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on           = var.always_on
    minimum_tls_version = "1.2"
    http2_enabled       = true
    ftps_state          = "Disabled"

    remote_debugging_enabled = false
    websockets_enabled       = false

    application_stack {
      dotnet_version = var.dotnet_version
    }
    scm_ip_restriction_default_action = "Allow"
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = var.application_insights_connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "SERVICEBUS_FQDN"                            = var.servicebus_fqdn
    "SERVICEBUS_QUEUE_NAME"                      = var.servicebus_queue_name
    "APP_COMPONENT"                              = "appservice-api"
    "APP_ENVIRONMENT"                            = "staging"
  }
}

# Autoscale on App Service Plan (min=1, default=1, max=2)
resource "azurerm_monitor_autoscale_setting" "this" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "as-${azurerm_service_plan.this.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  target_resource_id = azurerm_service_plan.this.id

  profile {
    name = "default"

    capacity {
      minimum = tostring(var.autoscale_min)
      default = tostring(var.autoscale_default)
      maximum = tostring(var.autoscale_max)
    }

    # Scale out rule
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT10M"
      }
    }

    # Scale in rule
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.this.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT20M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 35
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT20M"
      }
    }
  }
}

# Diagnostic settings for production app
data "azurerm_monitor_diagnostic_categories" "app" {
  resource_id = azurerm_linux_web_app.this.id
}

resource "azurerm_monitor_diagnostic_setting" "app" {
  name                       = "sendToLogAnalytics-appservice"
  target_resource_id         = azurerm_linux_web_app.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.app.log_category_types)
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.app.metrics)
    content {
      category = enabled_metric.value

    }
  }
}

# Diagnostic settings for staging slot (recommended for prod-like operations)
data "azurerm_monitor_diagnostic_categories" "slot" {
  count       = var.enable_slot ? 1 : 0
  resource_id = azurerm_linux_web_app_slot.staging[0].id
}

resource "azurerm_monitor_diagnostic_setting" "slot" {
  count                      = var.enable_slot ? 1 : 0
  name                       = "sendToLogAnalytics-appservice-slot"
  target_resource_id         = azurerm_linux_web_app_slot.staging[0].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.slot[0].log_category_types)
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(data.azurerm_monitor_diagnostic_categories.slot[0].metrics)
    content {
      category = enabled_metric.value

    }
  }
}
