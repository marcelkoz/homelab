#!/usr/bin/env python3

TARGET_FILE = "templates/application_servers/.env"

ENV_VARS = {
    "secret": {
        "cloudflare_api_token": "",
    },
    "metadata": {
        "domain": "",
        "sso_base_url": "",
    },
    "image_tag": {
        "actual_budget": "",
        "authentik": "",
        "daisy": "",
        # "gitea": "",
        # "grafana": "",
        "homarr": "",
        "pihole": "",
        "postgres": "",
        # "prometheus": "",
        "traefik": "",
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
            section += f"{format_var_name(namespace, var)}={ENV_VARS[namespace][var]}\n"
        sections.append(section)

    output = "\n\n".join(sections)
    with open(TARGET_FILE, "w") as f:
        f.write(output)


if __name__ == "__main__":
    main()
