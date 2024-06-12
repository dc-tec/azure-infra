terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.107.0"
    }
  }

  required_version = "1.8.5"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-prod-westeu-001"
    storage_account_name = "dcttfbackendprod001"
    container_name       = "tfstate"
    key                  = "azure/prd/terraform.tfstate"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-dct-prd-${var.location}"
  location = var.location_full
}

module "key_vault" {
  source     = "../../_modules/key_vault"
  depends_on = [azurerm_resource_group.main]

  for_each = local.keyvaults

  environment             = "prd"
  location                = var.location
  resource_group          = azurerm_resource_group.main.name
  name                    = "kv-${each.value[0].name}-prd-${var.location}"
  access_policies         = each.value[0].access_policies
  allowed_ips             = each.value[0].allowed_ips
  virtual_network_subnets = each.value[0].virtual_network_subnets
}
