param location string
param resourceGroupName string
param storageAccountName string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
}

module sa './storage.bicep' = {
  name: 'TerraformStorageAccount'
  scope: rg
  params: {
    location: location
    storageAccountName: storageAccountName
  }
}

