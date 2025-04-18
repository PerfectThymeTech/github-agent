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
        destination = "log-analytics"
        logAnalyticsConfiguration = {
          customerId = data.azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
          sharedKey  = data.azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
        }
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
                name = "github-runner"
                type = "github-runner"
                auth = [
                  {
                    triggerParameter = "personalAccessToken"
                    secretRef        = "personal-access-token"
                  }
                ]
                metadata = {
                  github-runner             = "https://api.github.com"
                  owner                     = var.github_org_name
                  runnerScope               = "org"
                  targetWorkflowQueueLength = "1"
                  # labels = local.github_labels
                }
              }
            ]
          }
        }
        secrets = [
          {
            identity    = module.user_assigned_identity.user_assigned_identity_id
            keyVaultUrl = azurerm_key_vault_secret.key_vault_secret_github_pat.versionless_id
            name        = "personal-access-token"
            value       = var.github_personal_access_token
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
                name  = "RUN_AS_ROOT"
                value = "true"
              },
              {
                name  = "RUNNER_NAME_PREFIX"
                value = "aca"
              },
              {
                name  = "RANDOM_RUNNER_SUFFIX"
                value = "true"
              },
              {
                name      = "ACCESS_TOKEN"
                secretRef = "personal-access-token"
              },
              {
                name  = "RUNNER_SCOPE"
                value = "org"
              },
              {
                name  = "ORG_NAME"
                value = var.github_org_name
              },
              {
                name  = "LABELS"
                value = local.github_labels
              },
              {
                name  = "RUNNER_WORKDIR"
                value = "/_work"
              },
              {
                name  = "RUNNER_GROUP"
                value = "default"
              },
              {
                name  = "DISABLE_AUTOMATIC_DEREGISTRATION"
                value = "false"
              },
              {
                name  = "EPHEMERAL"
                value = "1"
              },
              {
                name  = "DISABLE_AUTO_UPDATE"
                value = "1"
              },
              {
                name  = "START_DOCKER_SERVICE"
                value = "false"
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
