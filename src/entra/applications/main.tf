terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
  }
  
  required_version = "1.12.2"

  backend "azurerm" {
    resource_group_name  = "rg-dct-prd-westeu"
    storage_account_name = "dcttfbackendprod001"
    container_name       = "tfstate"
    key                  = "entraid/applications/terraform.tfstate"
  }
}

data "azuread_client_config" "current" {}

resource "random_uuid" "app_role_ids" {
  for_each = local.app_roles
}

