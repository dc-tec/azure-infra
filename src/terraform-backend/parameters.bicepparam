using './main.bicep'

param location = 'westeurope'
param resourceGroupName = 'rg-terraform-prod-westeu-001'
param storageAccountName = 'dcttfbackendprod001'

param tagValues = {
  partOf: 'terraform-backend'
  environment: 'prd'
  managedBy: 'bicep'
}
