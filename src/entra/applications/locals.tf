locals {
  applications = {
    for application in yamldecode(file("${path.module}/_configuration/applications.yaml")).applications :
    application.name => application...
  }
}
