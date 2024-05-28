param location string
param resourceGroupName string
param storageAccountName string
param tagValues object

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: location
  tags: tagValues
}

module storageAccount './storage.bicep' = {
  name: 'TerraformStorageAccount'
  scope: rg
  params: {
    location: location
    storageAccountName: storageAccountName
    tagValues: tagValues
  }
}

