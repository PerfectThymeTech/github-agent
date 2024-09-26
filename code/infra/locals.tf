locals {
  # General locals
  prefix        = "${lower(var.prefix)}-${var.environment}"
  github_labels = "aca"

  # Resource locals
  virtual_network = {
    resource_group_name = split("/", var.vnet_id)[4]
    name                = split("/", var.vnet_id)[8]
  }
  network_security_group = {
    resource_group_name = split("/", var.nsg_id)[4]
    name                = split("/", var.nsg_id)[8]
  }
  route_table = {
    resource_group_name = split("/", var.route_table_id)[4]
    name                = split("/", var.route_table_id)[8]
  }
  log_analytics_workspace = {
    resource_group_name = split("/", var.log_analytics_workspace_id)[4]
    name                = split("/", var.log_analytics_workspace_id)[8]
  }

  # Logging locals
  diagnostics_configurations = [
    {
      log_analytics_workspace_id = var.log_analytics_workspace_id
      storage_account_id         = ""
    }
  ]

  # CMK locals
  customer_managed_key = null
}
