
resource "random_string" "homarr_client_id" {
  length  = var.client_id_length
  special = var.client_id_special_chars
}

resource "authentik_provider_oauth2" "homarr" {
  name               = "homarr-provider"
  client_id          = random_string.homarr_client_id.result
  client_type        = var.oidc_client_type
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  allowed_redirect_uris = [
    {
      url           = "https://home.${var.domain_name}/api/auth/callback/oidc"
      matching_mode = "strict"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.profile.id,
  ]
}

resource "authentik_application" "homarr" {
  name               = "Homarr"
  slug               = "homarr"
  protocol_provider  = authentik_provider_oauth2.homarr.id
  policy_engine_mode = var.oidc_policy_engine_mode
  group              = var.application_group_name
}

resource "authentik_policy_binding" "homarr-editors-access" {
  target = authentik_application.homarr.uuid
  group  = authentik_group.groups["homarr-editors"].id
  order  = 0
}

resource "authentik_policy_binding" "homarr-admins-access" {
  target = authentik_application.homarr.uuid
  group  = authentik_group.groups["homarr-admins"].id
  order  = 0
}

output "homarr_id" {
  value = random_string.homarr_client_id.result
}
