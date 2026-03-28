
output "resource_group" {
  value = resource.azurerm_resource_group.environment_resource_group
}

output "storage_account" {
  value = resource.azurerm_storage_account.storage_account
}
