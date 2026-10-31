#!/usr/bin/env python3

TARGET_FILE = "roles/core_apps/templates/.env.j2"

ANSIBLE_VAR_PREFIX = "core_apps_template"

ENV_VARS = {
    "secret": {
        "cloudflare_api_token": "",
    },
    "metadata": {
        "domain": "",
        "sso_base_url": "",
    },
    "image_source": {
        "actual_budget": "actualbudget/actual-server",
        "authentik": "ghcr.io/goauthentik/server",
        "daisy_app": "daisy-app",
        "daisy_web": "daisy-web",
        # "gitea": "",
        # "grafana": "",
        "homarr": "ghcr.io/homarr-labs/homarr",
        "pihole": "pihole/pihole",
        "postgres": "postgres",
        # "prometheus": "",
        "traefik": "traefik",
    },
    "image_tag": {
        "actual_budget": "latest",
        "authentik": "2026.5.2",
        "daisy": "latest",
        # "gitea": "",
        # "grafana": "",
        "homarr": "latest",
        "pihole": "2026.10.0",
        "postgres": "16-alpine",
        # "prometheus": "",
        "traefik": "v3.7.16",
    },
    "homarr": {
        "encryption_key": "",
        "oidc_slug": "homarr",
        "oidc_client_id": "",
        "oidc_client_secret": "",
    },
    "authentik": {
        "db_name": "authentik",
        "db_user": "weeman",
        "db_pass": "",
        "encryption_key": "",
    },
    # "gitea": {
    #     "db_name": "gitea",
    #     "db_user": "bigguy",
    #     "db_pass": "",
    # },
    # "grafana": {"oidc_slug": "grafana", "oidc_client_id": "", "oidc_client_secret": ""},
}


def format_var_name(namespace, var_name):
    return f"{namespace}_{var_name}".upper()


def main():
    sections = []

    for namespace in ENV_VARS:
        section = f"## {namespace}\n".replace("_", " ").upper()
        for var in sorted(ENV_VARS[namespace].keys()):
            value = ENV_VARS[namespace][var]
            if value == "":
                value = f"{{{{ {ANSIBLE_VAR_PREFIX}_{namespace}_{var} }}}}".lower()

            section += f"{format_var_name(namespace, var)}={value}\n"
        sections.append(section)

    output = "\n\n".join(sections)
    with open(TARGET_FILE, "w") as f:
        f.write(output)


if __name__ == "__main__":
    main()
