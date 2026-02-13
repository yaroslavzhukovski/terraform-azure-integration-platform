variable "location" {
  type        = string
  description = "Azure region"
  default     = "swedencentral"
}

variable "name_prefix" {
  type        = string
  description = "Short prefix for naming (lowercase, no spaces). Example: 'yariorders'."
  default     = "prodstyle"
}

variable "environment" {
  type        = string
  description = "Single environment name for this project"
  default     = "main"
}

variable "system" {
  type        = string
  description = "Workload/system name"
  default     = "orders"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    iac = "terraform"
  }
}
variable "subnet_cidrs" {
  type = map(string)
  default = {
    function_integration = "10.10.10.0/24"
    private_endpoints    = "10.10.20.0/24"
    management           = "10.10.30.0/24"
    containerapps        = "10.10.32.0/21"
  }
}


variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]

  description = "VNet address space"
}

variable "private_dns_zones" {
  type = map(string)
  default = {
    blob       = "privatelink.blob.core.windows.net"
    servicebus = "privatelink.servicebus.windows.net"
    queue      = "privatelink.queue.core.windows.net"
    file       = "privatelink.file.core.windows.net"
    acr        = "privatelink.azurecr.io"
    webapps    = "privatelink.azurewebsites.net"
  }
}

variable "law_retention_in_days" {
  type        = number
  description = "Log Analytics Workspace retention in days"
  default     = 30
}

variable "law_sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}

variable "private_service_connection_name" {
  type        = string
  description = "Private Service Connection name for Storage Account"
  default     = "prodstyle-psc-blob"
}

variable "diagnostic_settings_name" {
  type        = string
  description = "Diagnostic Settings name for Storage Account"
  default     = "prodstyle-diagnostics"
}

variable "enable_storage_versioning" {
  type        = bool
  description = "Enable blob versioning in Storage Account"
  default     = true

}

variable "storage_retention_days_soft_delete" {
  type        = number
  description = "Number of days to retain soft deleted blobs in Storage Account"
  default     = 7
}

variable "storage_replication_type" {
  type        = string
  description = "Storage Account replication type"
  default     = "LRS"
}

variable "servicebus_sku" {
  type        = string
  description = "Service Bus SKU."
  default     = "Standard"
}

variable "servicebus_queue_name" {
  type        = string
  description = "Queue name for orders."
  default     = "orders"
}

variable "servicebus_diagnostic_settings_name" {
  type        = string
  description = "Diagnostic setting name for Service Bus."
  default     = "sendToLogAnalytics-servicebus"
}

variable "servicebus_partitioning_enabled" {
  type        = bool
  description = "Enable partitioning for the queue."
  default     = true
}

variable "servicebus_max_delivery_count" {
  type        = number
  description = "Max delivery count before DLQ."
  default     = 10
}

variable "servicebus_lock_duration" {
  type        = string
  description = "Lock duration (ISO8601), e.g. PT1M."
  default     = "PT1M"
}

variable "servicebus_default_message_ttl" {
  type        = string
  description = "Default message TTL (ISO8601), e.g. P7D."
  default     = "P7D"
}

variable "servicebus_dead_letter_on_expiration" {
  type        = bool
  description = "Dead-letter messages on expiration."
  default     = true
}

variable "servicebus_requires_duplicate_detection" {
  type        = bool
  description = "Enable duplicate detection."
  default     = true
}

variable "servicebus_duplicate_window" {
  type        = string
  description = "Duplicate detection window (ISO8601), e.g. PT10M."
  default     = "PT10M"
}

variable "app_service_api_sku_name" {
  description = "App Service Plan SKU for production-like features (autoscale + slots)."
  type        = string
  default     = "S1"
}

variable "app_service_api_always_on" {
  description = "Always On for production readiness."
  type        = bool
  default     = true
}

variable "app_service_api_enable_slot" {
  description = "Enable staging deployment slot."
  type        = bool
  default     = true
}

variable "app_service_api_enable_autoscale" {
  description = "Enable autoscale for App Service Plan."
  type        = bool
  default     = true
}

variable "app_service_api_autoscale_min" {
  description = "Minimum instance count."
  type        = number
  default     = 1
}

variable "app_service_api_autoscale_default" {
  description = "Default instance count."
  type        = number
  default     = 1
}

variable "app_service_api_autoscale_max" {
  description = "Maximum instance count (burst)."
  type        = number
  default     = 2
}

variable "app_service_api_dotnet_version" {
  description = "Built-in .NET stack version for App Service."
  type        = string
  default     = "8.0"
}

variable "vm_size" {
  description = "VM size for the jump/test VM."
  type        = string
  default     = "Standard_B1s"
}

variable "vm_admin_username" {
  description = "Admin username for the jump/test VM."
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_allowed_cidrs" {
  description = "CIDR blocks allowed to SSH/SCP into the VM. Restrict to your public IP where possible."
  type        = list(string)
  default     = ["*"]
}

variable "container_app_image" {
  description = "Container image for message processor container app. Example: <acr>.azurecr.io/message-processor:v1."
  type        = string
  default     = "acrstprodstylemainsc530rki.azurecr.io/message-processor:20260212101037"
}

variable "container_app_acr_login_server" {
  description = "ACR login server for the container app image, e.g. acrname.azurecr.io."
  type        = string
}

variable "container_app_target_port" {
  description = "Target port exposed by the container image."
  type        = number
  default     = 8080
}
