data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = "rg-dct-${var.environment}-${var.location}-001"
}

data "azuread_group" "main" {
  for_each = toset(var.access_groups)

  display_name = each.value
}

data "azuread_application" "main" {
  for_each     = can(var.application_names) ? toset(var.application_names) : toset([])
  display_name = each.value
}

resource "azurerm_key_vault" "main" {
  name                = var.name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"


  dynamic "access_policy" {
    for_each = var.access_policies

    content {
      tenant_id      = data.azurerm_client_config.current.tenant_id
      object_id      = data.azuread_group.main[access_policy.value.access_group].object_id
      application_id = can(data.azuread_application.main[access_policy.value.application].application_id) ? data.azuread_application.main[access_policy.value.application].application_id : null

      certificate_permissions = can(access_policy.value.certificate_permissions) ? access_policy.value.certificate_permissions : []
      key_permissions         = can(access_policy.value.key_permissions) ? access_policy.value.key_permissions : []
      secret_permissions      = can(access_policy.value.secret_permissions) ? access_policy.value.secret_permissions : []
      storage_permissions     = can(access_policy.value.storage_permissions) ? access_policy.value.storage_permissions : []
    }
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = var.allowed_ips
    virtual_network_subnet_ids = can(var.virtual_network_subnets) ? var.virtual_network_subnets : []
  }
}
