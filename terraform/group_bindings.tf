
# homarr
resource "authentik_policy_binding" "homarr-editors-access" {
  target = authentik_application.applications["homarr"].uuid
  group  = authentik_group.groups["homarr-editors"].id
  order  = 0
}

resource "authentik_policy_binding" "homarr-admins-access" {
  target = authentik_application.applications["homarr"].uuid
  group  = authentik_group.groups["homarr-admins"].id
  order  = 0
}

# gitea
resource "authentik_policy_binding" "gitea-restricted-access" {
  target = authentik_application.applications["gitea"].uuid
  group  = authentik_group.groups["gitea-restricted"].id
  order  = 0
}

resource "authentik_policy_binding" "gitea-users-access" {
  target = authentik_application.applications["gitea"].uuid
  group  = authentik_group.groups["gitea-users"].id
  order  = 0
}

resource "authentik_policy_binding" "gitea-admins-access" {
  target = authentik_application.applications["gitea"].uuid
  group  = authentik_group.groups["gitea-admins"].id
  order  = 0
}

# grafana
resource "authentik_policy_binding" "grafana-viewers-access" {
  target = authentik_application.applications["grafana"].uuid
  group  = authentik_group.groups["grafana-viewers"].id
  order  = 0
}

resource "authentik_policy_binding" "grafana-editors-access" {
  target = authentik_application.applications["grafana"].uuid
  group  = authentik_group.groups["grafana-editors"].id
  order  = 0
}

resource "authentik_policy_binding" "grafana-admins-access" {
  target = authentik_application.applications["grafana"].uuid
  group  = authentik_group.groups["grafana-admins"].id
  order  = 0
}

# pihole: TODO

# portainer
resource "authentik_policy_binding" "portainer-admins-access" {
  target = authentik_application.applications["portainer"].uuid
  group  = authentik_group.groups["portainer-admins"].id
  order  = 0
}

# traefik: TODO
