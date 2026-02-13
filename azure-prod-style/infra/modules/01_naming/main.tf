resource "random_string" "suffix" {
  count   = var.enable_random_suffix ? 1 : 0
  length  = var.random_suffix_length
  special = false
  upper   = false
}

locals {

  region_short_map = {
    swedencentral      = "sc"
    westeurope         = "we"
    northeurope        = "ne"
    eastus             = "eus"
    westus             = "wus"
    uksouth            = "uks"
    ukwest             = "ukw"
    germanywestcentral = "gwc"
  }

  region_short = lookup(local.region_short_map, lower(var.location), "xx")

  suffix = var.enable_random_suffix ? random_string.suffix[0].result : ""

  # base: <prefix>-<env>-<region>-<suffix>

  base_name = trim(join("-", compact([
    lower(var.name_prefix),
    lower(var.environment),
    local.region_short,
    local.suffix
  ])), "-")


  common_tags = merge(
    {
      env    = lower(var.environment)
      system = lower(var.system)
      region = lower(var.location)
      iac    = "terraform"
    },
    var.tags
  )

  # ---------- Resource names (opinionated) ----------
  rg_name   = "rg-${local.base_name}"
  vnet_name = "vnet-${local.base_name}"

  # Storage account name must be 3-24, lowercase letters/numbers only
  # We'll generate a sanitized base for storage (no dashes).
  storage_base = substr(replace("st${local.base_name}", "-", ""), 0, 24)
  storage_name = local.storage_base

  sb_namespace_name = "sb-${local.base_name}"

  # Monitoring
  law_name  = "law-${local.base_name}"
  appi_name = "appi-${local.base_name}"

  # Compute
  asp_name  = "asp-${local.base_name}"
  func_name = "func-${local.base_name}"
  cae_name  = "cae-${local.base_name}"
  ca_name   = "ca-${local.base_name}"

  # Private endpoints (examples)
  pe_blob_name = "pe-blob-${local.base_name}"
  pe_sb_name   = "pe-sb-${local.base_name}"

  # Container Registry
  acr_name = "acr${local.storage_base}"

  #App Service API
  app_service_api_name = "app-${local.base_name}"
}
