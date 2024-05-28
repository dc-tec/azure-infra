param storageAccountName string
param location string
param tagValues object

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  tags: tagValues 
  properties: {
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: [
        {
          action: 'Allow'
          value: '185.222.103.33'
        }
        {
          action: 'Allow'
          value: '217.62.17.140'
        }
      ]
    }
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2019-06-01' = {
  name: 'default'
  parent: storageAccount
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: 'tfstate'
  parent: blobServices
  properties: {
    publicAccess: 'None'
  }
}

