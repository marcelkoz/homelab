
resource "random_string" "grafana_client_id" {
  length  = var.client_id_length
  special = var.client_id_special_chars
}

resource "authentik_provider_oauth2" "grafana" {
  name               = "grafana-provider"
  client_id          = random_string.grafana_client_id.result
  client_type        = var.oidc_client_type
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  allowed_redirect_uris = [
    {
      url           = "https://grafana.${var.domain_name}/login/generic_oauth"
      matching_mode = "strict"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.profile.id,
  ]
}

resource "authentik_application" "grafana" {
  name               = "Grafana"
  slug               = "grafana"
  protocol_provider  = authentik_provider_oauth2.grafana.id
  policy_engine_mode = var.oidc_policy_engine_mode
  group              = var.application_group_name
}

resource "authentik_policy_binding" "grafana-viewers-access" {
  target = authentik_application.grafana.uuid
  group  = authentik_group.groups["grafana-viewers"].id
  order  = 0
}

resource "authentik_policy_binding" "grafana-editors-access" {
  target = authentik_application.grafana.uuid
  group  = authentik_group.groups["grafana-editors"].id
  order  = 0
}

resource "authentik_policy_binding" "grafana-admins-access" {
  target = authentik_application.grafana.uuid
  group  = authentik_group.groups["grafana-admins"].id
  order  = 0
}

output "grafana_id" {
  value = random_string.grafana_client_id.result
}
