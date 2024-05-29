data "azuread_group" "main" {
  for_each     = local.applications
  display_name = each.value[0].access_group
}

resource "azuread_service_principal" "main" {
  for_each = local.applications

  client_id = azuread_application.main[each.key].client_id
}

resource "azuread_app_role_assignment" "main" {
  for_each = local.applications

  app_role_id         = azuread_application.main[each.key].app_role_ids[each.value[0].app_roles[0].reference]
  principal_object_id = data.azuread_group.main[each.key].object_id
  resource_object_id  = azuread_service_principal.main[each.key].object_id
}
