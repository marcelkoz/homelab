
data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

locals {
  redirect_uris = {
    homarr = [{
      url           = "https://homarr.${var.domain_name}/api/auth/callback/oidc"
      matching_mode = "strict"
    }]

    gitea = [{
      url           = "https://git.${var.domain_name}/user/oauth2/authentik/callback"
      matching_mode = "strict"
    }]

    grafana = [{
      url           = "https://grafana.${var.domain_name}/login/generic_oauth"
      matching_mode = "strict"
    }]

    portainer = [{
      url           = "https://portainer.${var.domain_name}"
      matching_mode = "strict"
    }]
  }
}

resource "authentik_provider_oauth2" "providers" {
  for_each = var.oidc_applications

  name                  = each.value.provider_name
  client_id             = each.value.client_id # TODO: make this random
  client_type           = "confidential"
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-provider-invalidation-flow.id
  allowed_redirect_uris = local.redirect_uris[each.value.slug]
}

resource "authentik_application" "applications" {
  for_each = var.oidc_applications

  name               = each.value.application_name
  slug               = each.value.slug
  protocol_provider  = authentik_provider_oauth2.providers[each.key].id
  policy_engine_mode = "all"
  group              = var.application_group_name
}

resource "authentik_group" "groups" {
  for_each = var.user_groups

  name = each.value
}
