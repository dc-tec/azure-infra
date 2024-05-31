data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "main" {
  name = var.resource_group
}

data "azuread_group" "main" {
  for_each = can({
    for group in var.access_policies : group.access_group => group
    }) ? {
    for group in var.access_policies : group.access_group => group
  } : {}

  display_name = each.key
}

data "azuread_application" "main" {
  for_each = can({
    for application in var.access_policies : application.application_name => application
    }) ? {
    for application in var.access_policies : application.application_name => application
  } : {}

  display_name = each.key
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
      application_id = can(data.azuread_application.main[access_policy.value.application_name].application_id) ? data.azuread_application.main[access_policy.value.application_name].application_id : null

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
