
data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "backups_rg_prod" {
  name     = var.backups_resource_group_name_prod
  location = var.primary_resource_location
}

resource "azurerm_resource_group" "backups_rg_test" {
  name     = var.backups_resource_group_name_test
  location = var.primary_resource_location
}

resource "azuread_application" "backups_prod" {
  display_name = var.backups_application_name_prod
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "backups_prod" {
  client_id                    = azuread_application.backups_prod.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application" "backups_test" {
  display_name = var.backups_application_name_test
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "backups_test" {
  client_id                    = azuread_application.backups_test.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_user_assigned_identity" "automation_id_prod" {
  name                = var.automation_managed_identity_name_prod
  resource_group_name = resource.azurerm_resource_group.backups_rg_prod.name
  location            = resource.azurerm_resource_group.backups_rg_prod.location
}

resource "azurerm_user_assigned_identity" "automation_id_test" {
  name                = var.automation_managed_identity_name_test
  resource_group_name = resource.azurerm_resource_group.backups_rg_test.name
  location            = resource.azurerm_resource_group.backups_rg_test.location
}

resource "azurerm_storage_account" "backups_st_prod" {
  name                     = var.backups_storage_account_name_prod
  resource_group_name      = resource.azurerm_resource_group.backups_rg_prod.name
  location                 = resource.azurerm_resource_group.backups_rg_prod.location
  account_tier             = "Standard"
  access_tier              = "Cold"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_account" "backups_st_test" {
  name                     = var.backups_storage_account_name_test
  resource_group_name      = resource.azurerm_resource_group.backups_rg_test.name
  location                 = resource.azurerm_resource_group.backups_rg_test.location
  account_tier             = "Standard"
  access_tier              = "Cold"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_container" "backups_core_apps_blob_container_prod" {
  name                  = var.backups_core_apps_blob_container_name_prod
  storage_account_id    = resource.azurerm_storage_account.backups_st_prod.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups_core_apps_blob_container_test" {
  name                  = var.backups_core_apps_blob_container_name_test
  storage_account_id    = resource.azurerm_storage_account.backups_st_test.id
  container_access_type = "private"
}

# home assistant uses storage account keys instead of service principles
resource "azurerm_storage_container" "backups_home_assistant_blob_container_prod" {
  name                  = var.backups_home_assistant_blob_container_name_prod
  storage_account_id    = resource.azurerm_storage_account.backups_st_prod.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups_home_assistant_blob_container_test" {
  name                  = var.backups_home_assistant_blob_container_name_test
  storage_account_id    = resource.azurerm_storage_account.backups_st_test.id
  container_access_type = "private"
}

resource "azurerm_role_assignment" "backups_core_apps_prod" {
  scope                = resource.azurerm_storage_container.backups_core_apps_blob_container_prod.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = resource.azuread_service_principal.backups_prod.object_id
}

resource "azurerm_role_assignment" "backups_core_apps_test" {
  scope                = resource.azurerm_storage_container.backups_core_apps_blob_container_test.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = resource.azuread_service_principal.backups_test.object_id
}

#TODO: automation_id