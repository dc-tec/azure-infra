#TODO: Make it a bit more modular, not really needed for now
resource "azuread_application" "main" {
  for_each = local.applications

  display_name            = each.value[0].name
  identifier_uris         = [each.value[0].identifier_uris]
  owners                  = [data.azuread_client_config.current.object_id]
  sign_in_audience        = "AzureADMyOrg"
  group_membership_claims = [each.value[0].group_membership_claims]

  dynamic "app_role" {
    for_each = each.value[0].app_roles
    content {
      allowed_member_types = [for member_type in app_role.value.allowed_member_types : member_type]
      display_name         = app_role.value.name
      description          = app_role.value.description
      id                   = random_uuid.random[each.key].result
      value                = app_role.value.reference
    }
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    dynamic "resource_access" {
      for_each = each.value[0].resource_access
      content {
        id   = resource_access.value.id
        type = resource_access.value.type
      }
    }
  }

  dynamic "public_client" {
    for_each = try(length(each.value[0].public_client.redirect_uris), 0) > 0 ? [for public_client in each.value[0].public_client.redirect_uris : public_client] : []
    content {
      redirect_uris = [public_client.value]
    }
  }

  dynamic "web" {
    for_each = try(length(each.value[0].web.redirect_uris), 0) > 0 ? [for web in each.value[0].web.redirect_uris : web] : []
    content {
      homepage_url  = each.value[0].web.homepage_url
      redirect_uris = [web.value]
    }
  }

  feature_tags {
    enterprise = true
  }
}

#TODO: Use time based rotation and store the client secret in keyvault, we could then create a mechism to dynamically retrieve the secret for ArgoCD 
resource "azuread_application_password" "main" {
  for_each = local.applications

  application_id = azuread_application.main[each.key].id
}

