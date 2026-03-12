
resource "authentik_brand" "homelab" {
  domain         = "homelab"
  default        = true
  branding_title = "Homelab"

  flow_authentication = data.authentik_flow.default_authentication_flow.id
  flow_invalidation   = data.authentik_flow.default-provider-invalidation-flow.id
  flow_user_settings  = data.authentik_flow.default_user_settings_flow.id
}
