param location string
param resourceGroupName string
param storageAccountName string
param tagValues object

targetScope = 'subscription'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: location
  tags: tagValues
}

module storageAccount './storage.bicep' = {
  name: 'TerraformStorageAccount'
  scope: resourceGroup
  params: {
    location: location
    storageAccountName: storageAccountName
    tagValues: tagValues
  }
}
