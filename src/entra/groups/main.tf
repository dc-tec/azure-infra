terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.51.0"
    }
  }
  required_version = "1.8.5"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-prod-westeu-001"
    storage_account_name = "dcttfbackendprod001"
    container_name       = "tfstate"
    key                  = "entraid/groups/terraform.tfstate"
  }
}

data "azuread_client_config" "current" {}

data "azuread_users" "main" {
  for_each = local.groups

  user_principal_names = [for member in each.value[0].members : member]
}

resource "azuread_group" "main" {
  for_each = local.groups

  display_name     = each.value[0].name
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true

  members = [for member in data.azuread_users.main[each.key].users[*] : member.object_id]

}
