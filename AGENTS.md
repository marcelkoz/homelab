# AGENTS.md

Ansible homelab repository. `site.yml` is the main entry point; `pb_*.yml` are
standalone playbooks. Roles live in `roles/`, per-environment inventory in
`inventories/{prod,test}/`, and generated secrets plus templates in `runtime/`
(git-ignored — never commit them).

## Ansible

Follow the [Zen of Ansible](https://github.com/ansible-community/zen-of-ansible).
The principles that matter most here:

- Clear, concise, simple, readable. If it is hard to explain, it is a bad idea.
- Playbooks are not for programming: avoid clever Jinja2, deep `when` chains
  and loop-in-loop constructs.
- Declarative over imperative: use a module instead of `command`/`shell`
  whenever one exists.
- Convention over configuration: prefer sensible defaults over extra knobs.
- Give every play and task a descriptive `name`.

Other conventions:

- Use fully qualified collection names, e.g. `ansible.builtin.copy`,
  `community.docker.docker_container`.
- Standalone playbooks follow the format `pb_name.yml` and stay in the
  repository root. Do not add them to subdirectories.
- Add new tasks to the appropriate role rather than growing `site.yml`. Tag new
  role task files so they can be selected or skipped.
- Reference the existing global variables in `group_vars/all.yml` for file and
  directory modes instead of hardcoding numeric modes.

Load inventory, secrets and vault options with:

```bash
source scripts/ansible-args.sh <prod|test> <pass|prompt>
ansible-playbook $ANSIBLE_ARGS site.yml
```

Validate changes before finishing. Both checks are required:

```bash
ansible-playbook $ANSIBLE_ARGS site.yml --syntax-check
ansible-lint
```

`ansible-lint` must pass for new and modified files. The current baseline has
existing `yaml[line-length]` findings in
`roles/core_apps/vars/main/glance.yml`; do not add new violations, and do not
widen or relax the rules to hide them.

## Generated files

`roles/core_apps/templates/.env.j2` is generated. Do not edit it by hand; a
regeneration overwrites your changes.

1. Add or change the variable in the `ENV_VARS` dict in
   `scripts/repo-generate-template-vars.py`.
2. Run `scripts/repo-generate-template-vars.py` from the repository root.
3. If the variable is a template value (empty string in `ENV_VARS`), define it
   in `roles/core_apps/vars/main/main.yml` as `core_apps_template_<namespace>_<var>`.

## Python

Format Python scripts with `black` using the default configuration. There is no
project-specific `pyproject.toml`, so do not add one just for formatting:

```bash
black scripts/
```

## Documentation

If a change affects setup, configuration, commands or repository layout,
suggest the matching `README.md` update. Keep documentation edits limited to
what the change makes stale.
