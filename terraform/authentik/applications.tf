
locals {
  default_property_mapping = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.profile.id,
  ]

  default_authorization_flow_id = data.authentik_flow.default_authorization_flow.id
  default_invalidation_flow_id  = data.authentik_flow.default_provider_invalidation_flow.id

  standard_applications = {
    gitea = {
      name = "Gitea",
      slug = "gitea",
      url  = "https://git.${var.domain_name}/user/oauth2/authentik/callback",
      groups = [
        authentik_group.groups["gitea-restricted"].id,
        authentik_group.groups["gitea-users"].id,
        authentik_group.groups["gitea-admins"].id,
      ],
      property_mapping = [
        data.authentik_property_mapping_provider_scope.email.id,
        data.authentik_property_mapping_provider_scope.openid.id,
        data.authentik_property_mapping_provider_scope.profile.id,
        authentik_property_mapping_provider_scope.gitea.id,
      ],
    },

    grafana = {
      name = "Grafana",
      slug = "grafana",
      url  = "https://grafana.${var.domain_name}/login/generic_oauth",
      groups = [
        authentik_group.groups["grafana-viewers"].id,
        authentik_group.groups["grafana-editors"].id,
        authentik_group.groups["grafana-admins"].id,
      ],
    },

    homarr = {
      name = "Homarr",
      slug = "homarr",
      url  = "https://home.${var.domain_name}/api/auth/callback/oidc",
      groups = [
        authentik_group.groups["homarr-editors"].id,
        authentik_group.groups["homarr-admins"].id,
      ],
    },

    home_assistant = {
      name = "Home Assistant",
      slug = "home-assistant",
      url  = "https://ha.${var.domain_name}/auth/openid/callback",
      groups = [
        authentik_group.groups["home-assistant-users"].id,
        authentik_group.groups["home-assistant-admins"].id,
      ],
    },

    proxmox = {
      name = "Proxmox",
      slug = "proxmox",
      url  = "https://proxmox.${var.domain_name}:8006",
      groups = [
        authentik_group.groups["proxmox-admins"].id,
      ],
      subjet = "user_email"
    },
  }
}

resource "authentik_group" "groups" {
  for_each = var.user_groups

  name = each.value
}

resource "authentik_property_mapping_provider_scope" "gitea" {
  name       = "authentik gitea OAuth Mapping: OpenID 'gitea'"
  scope_name = "gitea"
  expression = <<EOF
gitea_claims = {}

if request.user.ak_groups.filter(name="gitea-users").exists():
    gitea_claims["gitea"] = "user"
if request.user.ak_groups.filter(name="gitea-admins").exists():
    gitea_claims["gitea"] = "admin"
if request.user.ak_groups.filter(name="gitea-restricted").exists():
    gitea_claims["gitea"] = "restricted"

return gitea_claims
EOF
}

module "standard_application" {
  source   = "./modules/homelab_application"
  for_each = local.standard_applications

  application_name  = each.value.name
  application_slug  = each.value.slug
  application_group = var.application_group_name
  client_type       = var.oidc_client_type

  authorization_flow_id = local.default_authorization_flow_id
  invalidation_flow_id  = local.default_invalidation_flow_id

  redirect_url           = each.value.url
  allowed_user_group_ids = each.value.groups
  property_mapping       = lookup(each.value, "property_mapping", local.default_property_mapping)
  subjet_mode            = lookup(each.value, "subjet", "hashed_user_id")
}
