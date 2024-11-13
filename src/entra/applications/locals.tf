locals {
  applications = {
    for application in yamldecode(file("${path.module}/_configuration/applications.yaml")).applications :
    application.name => application...
  }

  app_roles = merge(
    [
      for _, application in local.applications : {
        for _, app_role in application[0].app_roles :
        "${application[0].name}-${app_role.name}" => app_role
      }
    ]...
  )
}
