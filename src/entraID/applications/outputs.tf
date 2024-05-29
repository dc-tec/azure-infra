output "client_secret" {
  value     = [for client_secret in azuread_application_password.main : client_secret.value]
  sensitive = true
}
