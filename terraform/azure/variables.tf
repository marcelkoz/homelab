
variable "primary_resource_region" {
  type    = string
  default = "UK South"
}

variable "backups_storage_account_name_prod" {
  type = string
}

variable "backups_storage_account_name_test" {
  type = string
}
