
data "authentik_flow" "default_authentication_flow" {
  slug = "default-authentication-flow"
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

data "authentik_flow" "default_user_settings_flow" {
  slug = "default-user-settings-flow"
}

data "authentik_property_mapping_provider_scope" "email" {
  name = "authentik default OAuth Mapping: OpenID 'email'"
}

data "authentik_property_mapping_provider_scope" "openid" {
  name = "authentik default OAuth Mapping: OpenID 'openid'"
}

data "authentik_property_mapping_provider_scope" "profile" {
  name = "authentik default OAuth Mapping: OpenID 'profile'"
}

resource "authentik_group" "groups" {
  for_each = var.user_groups

  name = each.value
}
