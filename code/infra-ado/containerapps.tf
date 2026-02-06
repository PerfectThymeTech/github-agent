resource "azapi_resource" "container_apps_environment" {
  type      = "Microsoft.App/managedEnvironments@2024-03-01"
  parent_id = azurerm_resource_group.resource_group_container_app.id
  name      = "${local.prefix}-cae001"
  location  = var.location
  tags      = var.tags

  body = {
    properties = {
      # appInsightsConfiguration = { # Can only be set when DaprAIConnectionString is set to null
      #   connectionString = module.application_insights.application_insights_connection_string
      # }
      appLogsConfiguration = {
        destination = "azure-monitor"
      }
      daprAIConnectionString      = module.application_insights.application_insights_connection_string
      daprAIInstrumentationKey    = module.application_insights.application_insights_instrumentation_key
      daprConfiguration           = {}
      infrastructureResourceGroup = "${local.prefix}-cae001-rg"
      kedaConfiguration           = {}
      vnetConfiguration = {
        infrastructureSubnetId = azapi_resource.subnet_container_app.id
        internal               = true
      }
      workloadProfiles = [
        {
          name                = "Consumption"
          workloadProfileType = "Consumption"
        }
      ]
      zoneRedundant = false
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_container_app_environment" {
  for_each = { for index, value in local.diagnostics_configurations :
    index => {
      log_analytics_workspace_id = value.log_analytics_workspace_id,
      storage_account_id         = value.storage_account_id
    }
  }
  name                       = "applicationLogs-${each.key}"
  target_resource_id         = azapi_resource.container_apps_environment.id
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

resource "azapi_resource" "container_apps_job" {
  type      = "Microsoft.App/jobs@2024-03-01"
  parent_id = azurerm_resource_group.resource_group_container_app.id
  name      = "${local.prefix}-caj001"
  location  = var.location
  tags      = var.tags
  identity {
    type = "UserAssigned"
    identity_ids = [
      module.user_assigned_identity.user_assigned_identity_id
    ]
  }

  body = {
    properties = {
      configuration = {
        replicaRetryLimit = 1
        replicaTimeout    = 1800
        triggerType       = "Event"
        eventTriggerConfig = {
          parallelism            = 1
          replicaCompletionCount = 1
          scale = {
            minExecutions   = 0
            maxExecutions   = 10
            pollingInterval = 30
            rules = [
              {
                name = "azure-pipelines"
                type = "azure-pipelines"
                auth = [
                  {
                    triggerParameter = "organizationURL"
                    secretRef        = "organization-url"
                  },
                  {
                    triggerParameter = "personalAccessToken"
                    secretRef        = "personal-access-token"
                  }
                ]
                metadata = {
                  # poolName                             = azuredevops_agent_pool.agent_pool.name
                  poolID                               = azuredevops_agent_pool.agent_pool.id
                  organizationURLFromEnv               = "AZP_URL"
                  personalAccessTokenFromEnv           = "AZP_TOKEN"
                  targetPipelinesQueueLength           = 1
                  activationTargetPipelinesQueueLength = 0
                  requireAllDemands                    = false
                  requireAllDemandsAndIgnoreOthers     = false
                  jobsToFetch                          = 250
                  fetchUnfinishedJobsOnly              = false
                  caseInsensitiveDemandsProcessing     = false
                  # parent = var.azure_devops_parent_agent_name
                  # demands = var.azure_devops_demands
                }
              }
            ]
          }
        }
        secrets = [
          {
            identity    = module.user_assigned_identity.user_assigned_identity_id
            keyVaultUrl = azurerm_key_vault_secret.key_vault_secret_azure_devops_organization_url.versionless_id
            name        = "organization-url"
            value       = var.azure_devops_organization_url
          },
          {
            identity    = module.user_assigned_identity.user_assigned_identity_id
            keyVaultUrl = azurerm_key_vault_secret.key_vault_secret_azure_devops_pat.versionless_id
            name        = "personal-access-token"
            value       = var.azure_devops_pat
          }
        ]
      }
      environmentId = azapi_resource.container_apps_environment.id
      template = {
        containers = [
          {
            name = "github-runner"
            # args = []
            # command = []
            env = [
              {
                name      = "AZP_TOKEN"
                secretRef = "personal-access-token"
              },
              {
                name      = "AZP_URL"
                secretRef = "organization-url"
              },
              {
                name  = "AZP_POOL"
                value = azuredevops_agent_pool.agent_pool.name
              }
            ]
            image = var.container_image_reference
            # probes = []
            resources = {
              cpu    = 1.5
              memory = "3.0Gi"
            }
            volumeMounts = null
          }
        ]
        initContainers = null
        volumes        = null
      }
      workloadProfileName = "Consumption"
    }
  }
}
