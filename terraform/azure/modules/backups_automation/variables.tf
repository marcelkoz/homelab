
variable "environment_name" {
  type        = string
  description = "Name of the environment which is used in names."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the esource group to place resources in."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region of the esource group to place resources in."
}

variable "backups_storage_account_name" {
  type        = string
  description = "Name of the backups storage account."
}

variable "function_storage_account_name" {
  type        = string
  description = "Name of the storage account used by the function. This is globally unique."
}

variable "function_name" {
  type        = string
  description = "Name of the function app. This is unique to the region."
}

variable "function_runtime" {
  type        = string
  default     = "python"
  description = "Language runtime used by the function app."
}

variable "function_runtime_version" {
  type        = string
  default     = "3.13"
  description = "Version of the language runtime used by the function app."
}
