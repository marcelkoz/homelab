
data "azuread_client_config" "current" {}

# identity
resource "azurerm_resource_group" "environment_resource_group" {
  name     = "${var.environment_name}-${var.resource_group_name}"
  location = var.resource_region
}

resource "azuread_application" "entra_application" {
  display_name = "${var.entra_application_name} (${var.environment_name})"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "entra_service_principle" {
  client_id                    = resource.azuread_application.entra_application.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_user_assigned_identity" "automation_managed_identity" {
  name                = "${var.environment_name}-${var.automation_managed_identity_name}"
  resource_group_name = resource.azurerm_resource_group.environment_resource_group.name
  location            = resource.azurerm_resource_group.environment_resource_group.location
}

# resources
resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = resource.azurerm_resource_group.environment_resource_group.name
  location                 = resource.azurerm_resource_group.environment_resource_group.location
  account_tier             = "Standard"
  access_tier              = "Cold"
  account_replication_type = "ZRS"

  # for home assistant
  shared_access_key_enabled = true
}

resource "azurerm_storage_container" "core_apps" {
  name                  = "${var.environment_name}-${var.blob_container_name_core_apps}"
  storage_account_id    = resource.azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "home_assistant" {
  name                  = "${var.environment_name}-${var.blob_container_name_home_assistant}"
  storage_account_id    = resource.azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "opnsense" {
  name                  = "${var.environment_name}-${var.blob_container_name_opnsense}"
  storage_account_id    = resource.azurerm_storage_account.storage_account.id
  container_access_type = "private"
}

# role assignment
resource "azurerm_role_assignment" "entra_service_principle" {
  scope                = resource.azurerm_storage_container.core_apps.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = resource.azuread_service_principal.entra_service_principle.object_id
}

# NOTE: home assistant uses storage account access keys
# NOTE: opensense is work in progress
