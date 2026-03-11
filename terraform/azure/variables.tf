
variable "primary_resource_location" {
  type    = string
  default = "UK South"
}

variable "backups_resource_group_name_prod" {
  type    = string
  default = "prod-homelab-backups-rg-1"
}

variable "backups_resource_group_name_test" {
  type    = string
  default = "test-homelab-backups-rg-1"
}

variable "backups_storage_account_name_prod" {
  type = string
}

variable "backups_storage_account_name_test" {
  type = string
}

variable "backups_core_apps_blob_container_name_prod" {
  type    = string
  default = "prod-core-apps-backups"
}

variable "backups_core_apps_blob_container_name_test" {
  type    = string
  default = "test-core-apps-backups"
}

variable "backups_home_assistant_blob_container_name_prod" {
  type    = string
  default = "prod-home-assistant-backups"
}

variable "backups_home_assistant_blob_container_name_test" {
  type    = string
  default = "test-home-assistant-backups"
}

variable "backups_application_name_prod" {
  type    = string
  default = "Homelab Backups (prod)"
}

variable "backups_application_name_test" {
  type    = string
  default = "Homelab Backups (test)"
}

variable "automation_managed_identity_name_prod" {
  type    = string
  default = "prod-automation-id"
}

variable "automation_managed_identity_name_test" {
  type    = string
  default = "test-automation-id"
}
