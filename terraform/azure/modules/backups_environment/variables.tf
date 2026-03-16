
variable "resource_region" {
  type        = string
  description = "The Azure region to create the resources in."
}

variable "environment_name" {
  type        = string
  description = "Name of the environment which is used in names."
}

variable "resource_group_name" {
  type        = string
  default     = "homelab-backups-rg-1"
  description = "Name of the resource group. The environment name is prepended."
}

variable "storage_account_name" {
  type        = string
  description = "Name of the storage account. This is globally unique."
}

variable "blob_container_name_core_apps" {
  type        = string
  default     = "core-apps-backups"
  description = "Name of the core apps blob container. The environment name is prepended."
}

variable "blob_container_name_home_assistant" {
  type        = string
  default     = "home-assistant-backups"
  description = "Name of the home assistant blob container. The environment name is prepended."
}

variable "blob_container_name_opnsense" {
  type        = string
  default     = "opnsense-backups"
  description = "Name of the opnsense blob container. The environment name is prepended."
}

variable "entra_application_name" {
  type        = string
  default     = "Homelab Backups"
  description = "Name of the Entra ID service principle/app registration. The environment name is appended."
}

variable "automation_managed_identity_name" {
  type        = string
  default     = "automation-id"
  description = "Name of the managed identity. The environment name is prepended."
}
