resource Identifier 'Microsoft.App/managedEnvironments@2023-08-01-preview' = {
  name: ''
  location: location
  properties: {
    appInsightsConfiguration: {
      connectionString: 
    }
    appLogsConfiguration: {
      destination: ''
      logAnalyticsConfiguration: {
        
      }
    }
    openTelemetryConfiguration: {
      destinationsConfiguration: {
        dataDogConfiguration: {
          
        }
      }
      logsConfiguration: {
        destinations: [
          {

          }
        ]
      }
      metricsConfiguration:{
        destinations: [
          {

          }
        ]
      }
    }
    kedaConfiguration:{
      
    }
    peerAuthentication: {
      mtls: {
        enabled: true
      }
    }

  }
}

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: ''
  location: 'westeurope'
  properties: {
    sku: {
      family: 'A'
      name: 'premium'
    }
    tenantId: 'dwdw'
  }
}

resource kvk 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: 'mykey'
  parent: kv
  properties: {
    
  }
}

output test string = kvk.properties.secretUri
