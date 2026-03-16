
module "backups_prod" {
  source = "./modules/backups_environment"

  environment_name     = "prod"
  resource_region      = var.primary_resource_region
  storage_account_name = var.backups_storage_account_name_prod
}

module "backups_test" {
  source = "./modules/backups_environment"

  environment_name     = "test"
  resource_region      = var.primary_resource_region
  storage_account_name = var.backups_storage_account_name_test
}
