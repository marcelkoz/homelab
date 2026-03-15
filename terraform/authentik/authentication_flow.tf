
resource "authentik_flow" "authentication" {
  name        = "${var.resource_namespace}-authentication-flow"
  title       = var.authentication_flow_title
  slug        = "${var.resource_namespace}-authentication-flow"
  designation = "authentication"
}

resource "authentik_stage_password" "password" {
  name                          = "${var.resource_namespace}-authentication-password"
  backends                      = ["authentik.core.auth.InbuiltBackend"]
  allow_show_password           = true
  failed_attempts_before_cancel = 3
  configure_flow                = data.authentik_flow.default_password_change_flow.id
}

resource "authentik_stage_identification" "credentials" {
  name                      = "${var.resource_namespace}-authentication-credentials"
  user_fields               = ["username", "email"]
  password_stage            = resource.authentik_stage_password.password.id
  case_insensitive_matching = true
}

resource "authentik_stage_authenticator_validate" "mfa" {
  name                       = "${var.resource_namespace}-authentication-mfa-validate"
  device_classes             = ["totp", "webauthn"]
  not_configured_action      = "configure"
  webauthn_user_verification = "preferred"

  configuration_stages = [
    data.authentik_stage.default_totp_setup_stage.id,
    data.authentik_stage.default_webauthn_setup_stage.id,
  ]
}

resource "authentik_stage_user_login" "user_login" {
  name = "${var.resource_namespace}-authentication-login"
}

# credentials binding
resource "authentik_flow_stage_binding" "credentials" {
  target               = resource.authentik_flow.authentication.uuid
  stage                = resource.authentik_stage_identification.credentials.id
  evaluate_on_plan     = false
  re_evaluate_policies = true
  order                = 10
}

# password reset bindings
resource "authentik_flow_stage_binding" "force_password_reset_check" {
  target               = resource.authentik_flow.authentication.uuid
  stage                = resource.authentik_stage_prompt.force_password_reset.id
  evaluate_on_plan     = false
  re_evaluate_policies = true
  order                = 30
}

resource "authentik_policy_binding" "force_password_reset_check" {
  target = resource.authentik_flow_stage_binding.force_password_reset_check.id
  policy = resource.authentik_policy_expression.reset_password_check.id
  order  = 0
}

resource "authentik_flow_stage_binding" "force_password_reset_update" {
  target               = resource.authentik_flow.authentication.uuid
  stage                = resource.authentik_stage_user_write.force_password_reset.id
  evaluate_on_plan     = false
  re_evaluate_policies = true
  order                = 31
}

resource "authentik_policy_binding" "force_password_reset_update" {
  target = resource.authentik_flow_stage_binding.force_password_reset_update.id
  policy = resource.authentik_policy_expression.reset_password_update.id
  order  = 0
}

# mfa binding
resource "authentik_flow_stage_binding" "mfa" {
  target               = resource.authentik_flow.authentication.uuid
  stage                = resource.authentik_stage_authenticator_validate.mfa.id
  evaluate_on_plan     = false
  re_evaluate_policies = true
  order                = 50
}

# user login binding
resource "authentik_flow_stage_binding" "user_login" {
  target               = resource.authentik_flow.authentication.uuid
  stage                = resource.authentik_stage_user_login.user_login.id
  evaluate_on_plan     = false
  re_evaluate_policies = true
  order                = 100
}
