variable "resource_group_name" {
  type        = string
  description = "Resource group name."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "container_app_environment_name" {
  type        = string
  description = "Container Apps Environment name."
}

variable "container_app_name" {
  type        = string
  description = "Container App name."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics Workspace ID."
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Subnet ID for the Container Apps environment."
}

variable "container_name" {
  type        = string
  description = "Container name."
  default     = "app"
}

variable "container_image" {
  type        = string
  description = "Container image."
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "acr_login_server" {
  type        = string
  description = "ACR login server for image pulls."
}

variable "registry_identity_id" {
  type        = string
  description = "User-assigned identity resource ID used for container registry pulls."
}

variable "cpu" {
  type        = number
  description = "CPU."
  default     = 0.25
}

variable "memory" {
  type        = string
  description = "Memory (e.g. 0.5Gi, 1Gi)."
  default     = "0.5Gi"
}

variable "target_port" {
  type        = number
  description = "Ingress target port."
  default     = 8080
}

variable "min_replicas" {
  type        = number
  description = "Minimum replicas."
  default     = 0
}

variable "max_replicas" {
  type        = number
  description = "Maximum replicas."
  default     = 1
}

variable "container_env" {
  type        = map(string)
  description = "Environment variables passed to the container."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags."
  default     = {}
}
