output "backups_application_prod" {
  value = resource.azuread_application.backups_prod
}

output "backups_service_principle_prod" {
  value = resource.azuread_service_principal.backups_prod
}

output "backups_application_test" {
  value = resource.azuread_application.backups_test
}

output "backups_service_principle_test" {
  value = resource.azuread_service_principal.backups_test
}

output "automation_managed_identity" {
  value = resource.azurerm_user_assigned_identity.automation_id
}
