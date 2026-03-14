
variable "application_name" {
  type        = string
  description = "User friendly value for the name of the application. Should be capitalised."
}

variable "application_slug" {
  type        = string
  description = "Value used in application URL slugs and authentik resource names."
}

variable "application_group" {
  type        = string
  description = "Name of the group the application belongs to."
}

variable "allowed_user_group_ids" {
  type        = list(string)
  description = "List of user group ids allowed to access the application."
}

variable "client_type" {
  type        = string
  description = "Type of OIDC client the application will be."
}

variable "authorization_flow_id" {
  type        = string
  description = "Id for the authentik authorization flow."
}

variable "invalidation_flow_id" {
  type        = string
  description = "Id for the authentik invalidation flow."
}

variable "redirect_url" {
  type        = string
  description = "Redirect URL for the application."
}

variable "redirect_url_matching_mode" {
  type        = string
  default     = "strict"
  description = "Matching mode for the application redirect URL."
}

variable "policy_engine_mode" {
  type        = string
  default     = "any"
  description = "Policy engine mode (all or any) for the application."
}

variable "property_mapping" {
  type        = list(string)
  description = "List of authentik property mapping ids to include."
}

variable "subjet_mode" {
  type        = string
  default     = "hashed_user_id"
  description = "Define the user id that should be shared with the application. The default is usually fine."
}

variable "icon" {
  type        = string
  default     = ""
  description = "Path or URL to the icon for the application. Used in the authentik user interface."
}
