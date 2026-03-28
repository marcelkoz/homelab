
data "azurerm_storage_account" "backups_storage_account" {
  name                = var.backups_storage_account_name
  resource_group_name = var.resource_group_name
}

locals {
  storage_account_rbac_role   = "Storage Blob Data Contributor"
  function_container_endpoint = "${azurerm_storage_account.function_storage_account.primary_blob_endpoint}${azurerm_storage_container.function_container.name}"
}

resource "azurerm_storage_account" "function_storage_account" {
  name                     = var.function_storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "function_container" {
  name                  = "${var.environment_name}-${var.function_name}"
  storage_account_id    = azurerm_storage_account.function_storage_account.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "function_service_plan" {
  name                         = "${var.environment_name}-srv-plan"
  resource_group_name          = var.resource_group_name
  location                     = var.resource_group_location
  os_type                      = "Linux"
  sku_name                     = "FC1"
  maximum_elastic_worker_count = 1
}

resource "azurerm_function_app_flex_consumption" "backups_function" {
  name                = var.function_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  service_plan_id     = resource.azurerm_service_plan.function_service_plan.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = local.function_container_endpoint
  storage_authentication_type = "SystemAssignedIdentity"

  runtime_name                  = var.function_runtime
  runtime_version               = var.function_runtime_version
  maximum_instance_count        = 1
  instance_memory_in_mb         = 512
  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "BACKUP_STORAGE_ACCOUNT_NAME" = var.backups_storage_account_name
  }

  site_config {}
}

resource "azurerm_role_assignment" "function_storage_account" {
  scope                = resource.azurerm_storage_account.function_storage_account.id
  role_definition_name = local.storage_account_rbac_role
  principal_id         = resource.azurerm_function_app_flex_consumption.backups_function.identity[0].principal_id
}

resource "azurerm_role_assignment" "backups_storage_account" {
  scope                = data.azurerm_storage_account.backups_storage_account.id
  role_definition_name = local.storage_account_rbac_role
  principal_id         = resource.azurerm_function_app_flex_consumption.backups_function.identity[0].principal_id
}
