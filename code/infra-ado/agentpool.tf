resource "azuredevops_agent_pool" "agent_pool" {
  name = "${local.prefix}-pool001"

  auto_provision = false
  pool_type      = "automation"
  auto_update    = false
}
