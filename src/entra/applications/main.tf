terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.52.0"
    }
  }
  required_version = "1.9.5"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-prod-westeu-001"
    storage_account_name = "dcttfbackendprod001"
    container_name       = "tfstate"
    key                  = "entraid/applications/terraform.tfstate"
  }
}

data "azuread_client_config" "current" {}

resource "random_uuid" "random" {
  for_each = local.applications
}

