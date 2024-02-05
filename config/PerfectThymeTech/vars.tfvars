# General variables
location    = "northeurope"
environment = "prd"
prefix      = "gha"
tags = {
  "workload" = "github-runners"
}
log_analytics_workspace_id = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/DefaultResourceGroup-NEU/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-8f171ff9-2b5b-4f0f-aed5-7fa360a1d094-NEU"

# Github variables
github_org_name = "PerfectThymeTech"

# Container variables
container_image_reference = "ghcr.io/perfectthymetech/githubagentazure:main"

# Network variables
vnet_id                       = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-network/providers/Microsoft.Network/virtualNetworks/mycrp-prd-vnet001"
nsg_id                        = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-network/providers/Microsoft.Network/networkSecurityGroups/mycrp-prd-nsg001"
route_table_id                = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-network/providers/Microsoft.Network/routeTables/mycrp-prd-rt001"
subnet_cidr_container_app     = "10.0.3.0/27"
subnet_cidr_private_endpoints = "10.0.3.32/27"
private_dns_zone_id_key_vault = "/subscriptions/8f171ff9-2b5b-4f0f-aed5-7fa360a1d094/resourceGroups/mycrp-prd-global-dns/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
