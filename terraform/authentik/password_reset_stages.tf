# https://docs.goauthentik.io/users-sources/user/password_reset_on_login

# force password reset prompt
resource "authentik_policy_expression" "reset_password_check" {
  name       = "${var.resource_namespace}-reset-password-check"
  expression = file("${path.module}/policies/reset_password_check.py")
}

resource "authentik_stage_prompt_field" "password" {
  name        = "${var.resource_namespace}-password-field"
  field_key   = "password"
  label       = "Password"
  type        = "password"
  placeholder = "Password"
  required    = true
  order       = 501
}

resource "authentik_stage_prompt_field" "repeat_password" {
  name        = "${var.resource_namespace}-confirm-password-field"
  field_key   = "password_repeat"
  label       = "Confirm Password"
  type        = "password"
  placeholder = "Confirm Password"
  required    = true
  order       = 502
}

resource "authentik_stage_prompt_field" "change_password_text" {
  name          = "${var.resource_namespace}-change-password-text-field"
  field_key     = "change_password_text"
  label         = "Change Password Message"
  initial_value = "Please enter your new password."
  type          = "static"
  order         = 500
}

resource "authentik_policy_password" "password_policy" {
  name          = "${var.resource_namespace}-password-policy"
  error_message = "Password needs to be at least 10 characters. Must contain at least 1 digit and 1 symbol."

  length_min             = 10
  amount_digits          = 1
  amount_symbols         = 1
  zxcvbn_score_threshold = 2

  check_have_i_been_pwned = false
  check_static_rules      = true
  check_zxcvbn            = true
}

resource "authentik_stage_prompt" "force_password_reset" {
  name = "${var.resource_namespace}-force-password-reset-prompt"
  fields = [
    resource.authentik_stage_prompt_field.change_password_text.id,
    resource.authentik_stage_prompt_field.password.id,
    resource.authentik_stage_prompt_field.repeat_password.id,
  ]

  validation_policies = [
    resource.authentik_policy_password.password_policy.id,
  ]
}

# force password reset write
resource "authentik_policy_expression" "reset_password_update" {
  name       = "${var.resource_namespace}-reset-password-update"
  expression = file("${path.module}/policies/reset_password_update.py")
}

resource "authentik_stage_user_write" "force_password_reset" {
  name = "${var.resource_namespace}-force-password-reset-user-write-stage"
}
