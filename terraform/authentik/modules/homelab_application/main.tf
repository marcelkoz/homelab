
resource "random_string" "client_id" {
  length  = 20
  special = false
}

resource "authentik_provider_oauth2" "provider" {
  name               = "${var.application_slug}-provider"
  client_id          = random_string.client_id.result
  client_type        = var.client_type
  authorization_flow = var.authorization_flow_id
  invalidation_flow  = var.invalidation_flow_id
  allowed_redirect_uris = [
    {
      url           = var.redirect_url
      matching_mode = var.redirect_url_matching_mode
    }
  ]

  property_mappings = var.property_mapping
  sub_mode          = var.subjet_mode
}

resource "authentik_application" "application" {
  name               = var.application_name
  slug               = var.application_slug
  protocol_provider  = authentik_provider_oauth2.provider.id
  policy_engine_mode = var.policy_engine_mode
  group              = var.application_group
}

resource "authentik_policy_binding" "allowed_groups" {
  for_each = toset(var.allowed_user_group_ids)
  target   = authentik_application.application.uuid
  group    = each.key
  order    = 0
}

output "client_id" {
  value = random_string.client_id.result
}
