resource "azurerm_container_app_environment" "container_app_environment" {
  name                = "${local.prefix}-cae001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_container_app.name
  tags                = var.tags

  # dapr_application_insights_connection_string = module.application_insights.application_insights_connection_string
  infrastructure_resource_group_name = "${local.prefix}-cae001-rg"
  infrastructure_subnet_id           = azapi_resource.subnet_container_app.id
  internal_load_balancer_enabled     = true
  logs_destination                   = "azure-monitor"
  mutual_tls_enabled                 = false
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
  zone_redundancy_enabled = false
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_container_app_environment" {
  for_each = { for index, value in local.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }
  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azurerm_container_app_environment.container_app_environment.id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id == "" ? null : each.value.log_analytics_workspace_id
  storage_account_id         = each.value.storage_account_id == "" ? null : each.value.storage_account_id

  dynamic "enabled_log" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_container_app_environment.log_category_groups
    content {
      category_group = entry.value
    }
  }

  dynamic "enabled_metric" {
    iterator = entry
    for_each = data.azurerm_monitor_diagnostic_categories.diagnostic_categories_container_app_environment.metrics
    content {
      category = entry.value
    }
  }
}

resource "azurerm_container_app_job" "container_app_job" {
  name                = "${local.prefix}-caj001"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group_container_app.name
  tags                = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      module.user_assigned_identity.user_assigned_identity_id
    ]
  }

  container_app_environment_id = azurerm_container_app_environment.container_app_environment.id
  event_trigger_config {
    parallelism              = 1
    replica_completion_count = 1
    scale {
      max_executions              = 10
      min_executions              = 0
      polling_interval_in_seconds = 30
      rules {
        name             = "azure-pipelines"
        custom_rule_type = "azure-pipelines"
        authentication {
          trigger_parameter = "organizationURL"
          secret_name       = "organization-url"
        }
        authentication {
          trigger_parameter = "personalAccessToken"
          secret_name       = "personal-access-token"
        }
        metadata = {
          # poolName                             = azuredevops_agent_pool.agent_pool.name
          poolID                               = azuredevops_agent_pool.agent_pool.id
          organizationURLFromEnv               = "AZP_URL"
          personalAccessTokenFromEnv           = "AZP_TOKEN"
          targetPipelinesQueueLength           = 1
          activationTargetPipelinesQueueLength = 0
          requireAllDemands                    = "False"
          requireAllDemandsAndIgnoreOthers     = "False"
          jobsToFetch                          = 250
          fetchUnfinishedJobsOnly              = "False"
          caseInsensitiveDemandsProcessing     = "False"
          # parent = var.azure_devops_parent_agent_name
          # demands = var.azure_devops_demands
        }
      }
    }
  }
  replica_retry_limit        = 1
  replica_timeout_in_seconds = 1800
  secret {
    name                = "organization-url"
    value               = var.azure_devops_organization_url
    identity            = module.user_assigned_identity.user_assigned_identity_id
    key_vault_secret_id = azurerm_key_vault_secret.key_vault_secret_azure_devops_organization_url.versionless_id
  }
  secret {
    name                = "personal-access-token"
    value               = var.azure_devops_pat
    identity            = module.user_assigned_identity.user_assigned_identity_id
    key_vault_secret_id = azurerm_key_vault_secret.key_vault_secret_azure_devops_pat.versionless_id
  }
  template {
    container {
      name   = "azuredevops-runner"
      cpu    = 1.5
      memory = "3Gi"
      image  = var.container_image_reference
      env {
        name        = "AZP_TOKEN"
        secret_name = "personal-access-token"
      }
      env {
        name        = "AZP_URL"
        secret_name = "organization-url"
      }
      env {
        name  = "AZP_POOL"
        value = azuredevops_agent_pool.agent_pool.name
      }
    }
  }
  workload_profile_name = "Consumption"
}
