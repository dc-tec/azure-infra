locals {
  role_assignments = flatten([
    for policy in var.access_policies : concat([
      for group in policy.groups : {
        role_name = policy.role_name
        principal = group
        type      = "group"
      }],
      [for app in policy.applications : {
        role_name = policy.role_name
        principal = app
        type      = "application"
      }]
    )
  ])
}

