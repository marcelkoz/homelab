
resource "authentik_property_mapping_provider_scope" "gitea" {
  name       = "authentik gitea OAuth Mapping: OpenID 'gitea'"
  scope_name = "gitea"
  expression = <<EOF
gitea_claims = {}

if request.user.ak_groups.filter(name="gitea-users").exists():
    gitea_claims["gitea"] = "user"
if request.user.ak_groups.filter(name="gitea-admins").exists():
    gitea_claims["gitea"] = "admin"
if request.user.ak_groups.filter(name="gitea-restricted").exists():
    gitea_claims["gitea"] = "restricted"

return gitea_claims
EOF
}
