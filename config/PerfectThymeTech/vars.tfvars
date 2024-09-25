# General variables
location    = "northeurope"
environment = "prd"
prefix      = "ghr"
tags = {
  "workload" = "github-runners"
}
log_analytics_workspace_id = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-logging-rg/providers/Microsoft.OperationalInsights/workspaces/ptt-dev-log001"

# Github variables
github_org_name = "PerfectThymeTech"

# Container variables
container_image_reference = "ghcr.io/perfectthymetech/githubagentazure:main"

# Network variables
vnet_id                       = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-hub-northeurope-rg/providers/Microsoft.Network/virtualNetworks/ptt-dev-vnet001"
nsg_id                        = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-hub-northeurope-rg/providers/Microsoft.Network/networkSecurityGroups/ptt-dev-default-nsg001"
route_table_id                = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-hub-northeurope-rg/providers/Microsoft.Network/routeTables/ptt-dev-default-rt001"
subnet_cidr_container_app     = "10.0.1.192/26"
subnet_cidr_private_endpoints = "10.0.2.0/26"
private_dns_zone_id_key_vault = "/subscriptions/e82c5267-9dc4-4f45-ac13-abdd5e130d27/resourceGroups/ptt-dev-privatedns-rg/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
