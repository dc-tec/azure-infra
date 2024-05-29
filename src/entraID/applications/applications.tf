#TODO: Make it a bit more modular, not really needed for now
resource "azuread_application" "main" {
  for_each = local.applications

  display_name            = each.value[0].name
  identifier_uris         = [each.value[0].identifier_uris]
  owners                  = [data.azuread_client_config.current.object_id]
  sign_in_audience        = "AzureADMyOrg"
  group_membership_claims = [each.value[0].group_membership_claims]

  app_role {
    allowed_member_types = [for allowed_member_type in each.value[0].app_roles[0].allowed_member_types : allowed_member_type]
    display_name         = each.value[0].app_roles[0].name
    description          = each.value[0].app_roles[0].description
    id                   = random_uuid.random[each.key].result
    value                = each.value[0].app_roles[0].reference
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
  }

  public_client {
    redirect_uris = [for redirect_uri in each.value[0].public_client_redirect_uris : redirect_uri]
  }

  web {
    homepage_url  = each.value[0].homepage_url
    redirect_uris = [for redirect_uri in each.value[0].web_redirect_uris : redirect_uri]
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

