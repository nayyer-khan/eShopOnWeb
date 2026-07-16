param webAppName string
param sku string = 'F1'
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location

  sku: {
    name: sku
    tier: 'Free'
    size: sku
    capacity: 1
  }

  kind: 'app'

  properties: {
    reserved: false
  }
}

// App Service - Windows .NET 8
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: 'v8.0'    // ✅ Windows .NET runtime
      use32BitWorkerProcess: true    //  CRITICAL: Required for F1 Free Tier Windows plans!
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}
