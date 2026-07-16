param webAppName string
param sku string = 'B1'
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

// App Service Plan - Windows F1 Free Tier
resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: false           // ✅ Windows
  }
  sku: {
    name: sku                 // ✅ F1 Free
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
