
resource "authentik_brand" "homelab" {
  domain         = "homelab"
  default        = true
  branding_title = "Homelab"

  branding_favicon = "homelab_favicon.svg"
  branding_logo    = "homelab_logo.svg"

  flow_authentication = resource.authentik_flow.authentication.uuid
  flow_invalidation   = data.authentik_flow.default_invalidation_flow.id
  flow_user_settings  = data.authentik_flow.default_user_settings_flow.id
}
