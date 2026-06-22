@description('Deployment mode: static web app managed API or split web+functions hosting')
@allowed([
  'swa'
  'split'
])
param deploymentMode string = 'swa'

@description('Azure region for deployed resources')
param location string = resourceGroup().location

@description('Environment short name, for example dev/test/prod')
param environmentName string = 'dev'

@description('Base name used for resources')
param appName string = 'gpv2estimator'

@description('SKU for Azure Static Web App')
@allowed([
  'Free'
  'Standard'
])
param staticSiteSku string = 'Standard'

@description('App Service plan SKU name for split deployment mode')
param appServiceSkuName string = 'B1'

var suffix = toLower('${appName}-${environmentName}')
var storageName = toLower(replace('st${uniqueString(resourceGroup().id, suffix)}', '-', ''))
var functionAppName = toLower('func-${suffix}')
var webAppName = toLower('web-${suffix}')
var staticSiteName = toLower('swa-${suffix}')
var appInsightsName = 'appi-${suffix}'
var functionPlanName = 'asp-func-${suffix}'
var appServicePlanName = 'asp-${suffix}'

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: null
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }

  resource functionPlan 'Microsoft.Web/serverfarms@2024-04-01' = {
    name: functionPlanName
    location: location
    sku: {
      name: 'Y1'
      tier: 'Dynamic'
    }
    kind: 'functionapp'
    properties: {}
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    supportsHttpsTrafficOnly: true
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = if (deploymentMode == 'split') {
  name: appServicePlanName
  location: location
  sku: {
    name: appServiceSkuName
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource functionApp 'Microsoft.Web/sites@2024-04-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp,linux'
  properties: {
    httpsOnly: true
    serverFarmId: functionPlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      http20Enabled: true
    }
  }
}

resource webApp 'Microsoft.Web/sites@2024-04-01' = if (deploymentMode == 'split') {
  name: webAppName
  location: location
  kind: 'app,linux'
  properties: {
    httpsOnly: true
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8080'
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appInsights.properties.ConnectionString
        }
      ]
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      http20Enabled: true
    }
  }
}

resource staticSite 'Microsoft.Web/staticSites@2023-12-01' = if (deploymentMode == 'swa') {
  name: staticSiteName
  location: location
  sku: {
    name: staticSiteSku
    tier: staticSiteSku
  }
  properties: {
    allowConfigFileUpdates: true
    publicNetworkAccess: 'Enabled'
  }
}

output deploymentModeOutput string = deploymentMode
output functionAppName string = functionApp.name
output webAppName string = deploymentMode == 'split' ? webApp.name : ''
output staticWebAppName string = deploymentMode == 'swa' ? staticSite.name : ''
output applicationInsightsName string = appInsights.name
output storageAccountName string = storage.name
