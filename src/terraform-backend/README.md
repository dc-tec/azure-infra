This directory contains the Bicep code to create a Resource Group and Storage Account in Azure using Bicep. This storage account is used to store Terraform statefiles.

These can be deployed using the following command:

```bash
az deployment sub create --template-file main.bicep --parameters parameters.bicepparam --location westeurope
```
