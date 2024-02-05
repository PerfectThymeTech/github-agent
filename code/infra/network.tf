resource "azapi_resource" "subnet_container_app" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "ContainerAppSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = var.subnet_cidr_container_app
      delegations = [
        {
          name = "ContainerAppDelegation"
          properties = {
            serviceName = "Microsoft.App/environments"
          }
        }
      ]
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}

resource "azapi_resource" "subnet_private_endpoints" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2022-07-01"
  name      = "CAPrivateEndpointSubnet"
  parent_id = data.azurerm_virtual_network.virtual_network.id

  body = jsonencode({
    properties = {
      addressPrefix = var.subnet_cidr_private_endpoints
      delegations = []
      ipAllocations = []
      networkSecurityGroup = {
        id = data.azurerm_network_security_group.network_security_group.id
      }
      privateEndpointNetworkPolicies    = "Enabled"
      privateLinkServiceNetworkPolicies = "Enabled"
      routeTable = {
        id = data.azurerm_route_table.route_table.id
      }
      serviceEndpointPolicies = []
      serviceEndpoints        = []
    }
  })
}
