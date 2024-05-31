locals {
  keyvaults = {
    for keyvault in yamldecode(file("${path.module}/_configuration/keyvault_config.yaml")).keyvaults : keyvault.name => keyvault...
  }
}
