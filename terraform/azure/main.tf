
resource "azurerm_resource_group" "backups_rg" {
  name     = var.backups_resource_group_name
  location = var.primary_resource_location
}

resource "azurerm_storage_account" "backups_st" {
  name                     = var.backups_storage_account_name
  resource_group_name      = resource.azurerm_resource_group.backups_rg.name
  location                 = resource.azurerm_resource_group.backups_rg.location
  account_tier             = "Standard"
  access_tier              = "Cold"
  account_replication_type = "ZRS"
}

resource "azurerm_storage_container" "backups_blob_container_prod" {
  name                  = var.backups_blob_container_name_prod
  storage_account_id    = resource.azurerm_storage_account.backups_st.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups_blob_container_test" {
  name                  = var.backups_blob_container_name_test
  storage_account_id    = resource.azurerm_storage_account.backups_st.id
  container_access_type = "private"
}
