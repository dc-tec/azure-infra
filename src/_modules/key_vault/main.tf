data "azurerm_subscription" "primary" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group
}

data "azuread_group" "main" {
  for_each = { for role in local.role_assignments : role.principal => role if role.type == "group" }

  display_name = each.key
}

data "azuread_application" "main" {
  for_each = { for role in local.role_assignments : role.principal => role if role.type == "application" }

  display_name = each.key
}

resource "azurerm_key_vault" "main" {
  name                      = var.name
  location                  = data.azurerm_resource_group.main.location
  resource_group_name       = data.azurerm_resource_group.main.name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  sku_name                  = "standard"
  enable_rbac_authorization = true

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.allowed_ips
    virtual_network_subnet_ids = can(var.virtual_network_subnets) ? var.virtual_network_subnets : []
  }
}

resource "azurerm_role_assignment" "main" {
  for_each = { for role in local.role_assignments : "${role.role_name}-${role.principal}" => role }

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = each.value.role_name
  principal_id         = each.value.type == "group" ? data.azuread_group.main[each.value.principal].object_id : data.azuread_application.main[each.value.principal].object_id
}


