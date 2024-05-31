locals {
  groups = {
    for group in yamldecode(file("${path.module}/_configuration/groups.yaml")).groups :
    group.name => group...
  }
}
