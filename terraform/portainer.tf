
resource "random_string" "portainer_client_id" {
  length  = var.client_id_length
  special = var.client_id_special_chars
}

resource "authentik_provider_oauth2" "portainer" {
  name               = "portainer-provider"
  client_id          = random_string.portainer_client_id.result
  client_type        = var.oidc_client_type
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  allowed_redirect_uris = [
    {
      url           = "https://portainer.${var.domain_name}"
      matching_mode = "strict"
    }
  ]

  property_mappings = [
    data.authentik_property_mapping_provider_scope.email.id,
    data.authentik_property_mapping_provider_scope.openid.id,
    data.authentik_property_mapping_provider_scope.profile.id,
  ]
}

resource "authentik_application" "portainer" {
  name               = "Portainer"
  slug               = "portainer"
  protocol_provider  = authentik_provider_oauth2.portainer.id
  policy_engine_mode = var.oidc_policy_engine_mode
  group              = var.application_group_name
}

resource "authentik_policy_binding" "portainer-admins-access" {
  target = authentik_application.portainer.uuid
  group  = authentik_group.groups["portainer-admins"].id
  order  = 0
}

output "portainer_id" {
  value = random_string.portainer_client_id.result
}
