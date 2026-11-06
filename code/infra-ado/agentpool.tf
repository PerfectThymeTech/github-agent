resource "azuredevops_agent_pool" "agent_pool" {
  name = "${local.prefix}-pool001"

  auto_provision = false
  pool_type      = "automation"
  auto_update    = false
}

resource "null_resource" "agent_pool_dummy_agent" {
  triggers = {
    agent_pool_id = azuredevops_agent_pool.agent_pool.id
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/scripts/"
    command     = "pwsh ./Add-DummyAgent.ps1 -AzureDevOpsOrganizationUrl ${var.azure_devops_organization_url} -AzureDevOpsAgentPoolId ${azuredevops_agent_pool.agent_pool.id}"
    environment = {}
  }

  depends_on = []
}
