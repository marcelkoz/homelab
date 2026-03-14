
# authentik
variable "application_group_name" {
  type    = string
  default = "homelab-sso"
}

variable "resource_namespace" {
  type    = string
  default = "homelab"
}

variable "domain_name" {
  type = string
}

variable "oidc_client_type" {
  type    = string
  default = "confidential"
}

variable "oidc_policy_engine_mode" {
  type    = string
  default = "any"
}

variable "client_id_length" {
  type    = number
  default = 20
}

# client ids do not work well with special chars
variable "client_id_special_chars" {
  type    = bool
  default = false
}

variable "user_groups" {
  type = set(string)
  default = [
    "homarr-editors",
    "homarr-admins",
    "home-assistant-users",
    "home-assistant-admins",
    "gitea-restricted",
    "gitea-users",
    "gitea-admins",
    "grafana-viewers",
    "grafana-editors",
    "grafana-admins",
    "pihole-admins",
    "traefik-dashboard-viewers",
    "proxmox-admins",
  ]
}
