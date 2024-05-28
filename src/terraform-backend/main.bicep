param location string
param resourceGroupName string
param storageAccountName string
param tagValues object

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: tagValues
}

module sa './storage.bicep' = {
  name: 'TerraformStorageAccount'
  scope: rg
  params: {
    location: location
    storageAccountName: storageAccountName
    tagValues: tagValues
  }
}

