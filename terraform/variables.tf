
# authentik provider
variable "authentik_url" {
  type = string
}

variable "authentik_token" {
  type      = string
  sensitive = true
}
