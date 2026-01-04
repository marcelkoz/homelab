
# authentik
variable "application_group_name" {
  type    = string
  default = "homelab-sso"
}

variable "domain_name" {
  type = string
}

variable "oidc_applications" {
  type = map(object({
    application_name = string
    provider_name    = string
    client_id        = string
    slug             = string
  }))

  default = {
    homarr = {
      application_name = "Homarr"
      provider_name    = "homarr-provider"
      client_id        = "homarr"
      slug             = "homarr"
    }

    gitea = {
      application_name = "Gitea"
      provider_name    = "gitea-provider"
      client_id        = "gitea"
      slug             = "gitea"
    }

    grafana = {
      application_name = "Grafana"
      provider_name    = "grafana-provider"
      client_id        = "grafana"
      slug             = "grafana"
    }

    portainer = {
      application_name = "Portainer"
      provider_name    = "portainer-provider"
      client_id        = "portainer"
      slug             = "portainer"
    }
  }
}

variable "user_groups" {
  type = set(string)
  default = [
    "homarr-editors",
    "homarr-admins",
    "gitea-restricted",
    "gitea-users",
    "gitea-admins",
    "grafana-viewers",
    "grafana-editors",
    "grafana-admins",
    "portainer-admins",
  ]
}
