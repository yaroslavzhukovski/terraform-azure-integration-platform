locals {
  subnets = {
    snet-function-integration = {
      name             = "snet-function-integration"
      address_prefixes = [var.subnet_cidrs.function_integration]

      delegations = [
        {
          name = "delegation-appservice"
          service_delegation = {
            name = "Microsoft.App/environments"
          }
        }
      ]
    }

    snet-private-endpoints = {
      name             = "snet-private-endpoints"
      address_prefixes = [var.subnet_cidrs.private_endpoints]

      private_endpoint_network_policies             = "Disabled"
      private_link_service_network_policies_enabled = true
    }

    snet-management = {
      name             = "snet-management"
      address_prefixes = [var.subnet_cidrs.management]
      network_security_group = {
        id = azurerm_network_security_group.management.id
      }
    }

    snet-containerapps = {
      name             = "snet-containerapps"
      address_prefixes = [var.subnet_cidrs.containerapps]

      delegations = [
        {
          name = "delegation-containerapps"
          service_delegation = {
            name = "Microsoft.App/environments"
          }
        }
      ]
    }
  }
}
