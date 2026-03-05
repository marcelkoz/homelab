
variable "primary_resource_location" {
  type    = string
  default = "UK South"
}

variable "backups_resource_group_name" {
  type    = string
  default = "homelab-backups-rg-1"
}

variable "backups_storage_account_name" {
  type = string
}

variable "backups_application_name_prod" {
  type    = string
  default = "Homelab Backups (prod)"
}

variable "backups_application_name_test" {
  type    = string
  default = "Homelab Backups (test)"
}

variable "automation_managed_identity_name" {
  type    = string
  default = "automation-id"
}

variable "backups_blob_container_name_prod" {
  type    = string
  default = "backups-prod"
}

variable "backups_blob_container_name_test" {
  type    = string
  default = "backups-test"
}

