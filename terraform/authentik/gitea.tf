
resource "random_string" "gitea_client_id" {
  length  = var.client_id_length
  special = var.client_id_special_chars
}

resource "authentik_provider_oauth2" "gitea" {
  name               = "gitea-provider"
  client_id          = random_string.gitea_client_id.result
  client_type        = var.oidc_client_type
  authorization_flow = data.authentik_flow.default_authorization_flow.id
  invalidation_flow  = data.authentik_flow.default_invalidation_flow.id
  allowed_redirect_uris = [
    {
      url           = "https://git.${var.domain_name}/user/oauth2/authentik/callback"
      matching_mode = "strict"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.profile.id,
    authentik_property_mapping_provider_scope.gitea.id,
  ]
}

resource "authentik_application" "gitea" {
  name               = "Gitea"
  slug               = "gitea"
  protocol_provider  = authentik_provider_oauth2.gitea.id
  policy_engine_mode = var.oidc_policy_engine_mode
  group              = var.application_group_name
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

resource "authentik_policy_binding" "gitea-restricted-access" {
  target = authentik_application.gitea.uuid
  group  = authentik_group.groups["gitea-restricted"].id
  order  = 0
}

resource "authentik_policy_binding" "gitea-users-access" {
  target = authentik_application.gitea.uuid
  group  = authentik_group.groups["gitea-users"].id
  order  = 0
}

resource "authentik_policy_binding" "gitea-admins-access" {
  target = authentik_application.gitea.uuid
  group  = authentik_group.groups["gitea-admins"].id
  order  = 0
}

output "gitea_id" {
  value = random_string.gitea_client_id.result
}
