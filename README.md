
# Homelab

### Templates
The directory `templates` contains config file templates essential to run the services in the ansible playbooks.

Copy the configs: `cp -r templates runtime/ENV`



### Ansible

#### Vault
Create an ansible vault file to store secrets.

```bash
ansible-vault create runtime/prod/secrets.yml
ansible-vault create runtime/test/secrets.yml
```

Note: The templates directory contains a sample secrets file.

Load the inventory, secrets and vault options into `$ANSIBLE_ARGS` by sourcing
`scripts/ansible-args.sh`. Do not execute it.

```bash
source scripts/ansible-args.sh prod/test pass # vault password file
source scripts/ansible-args.sh prod/test prompt # ask for the vault password
ansible-playbook $ANSIBLE_ARGS site.yml
```

Use `test` instead of `prod` for the test environment.

Run the pihole bootstrap DNS playbook:

```ansible-playbook $ANSIBLE_ARGS pihole_dns.yml -e @./runtime/prod_pihole_dns.yml```

#### Useful Commands

List of available tags.

`ansible-playbook site.yml --list-tags`

List of available tasks.

`ansible-playbook site.yml --list-tasks`

List of hosts.

`ansible-playbook $ANSIBLE_ARGS site.yml --list-hosts`

Run specific tags.

`ansible-playbook $ANSIBLE_ARGS site.yml --tags TAG1,TAG2`

Skip specific tags.

`ansible-playbook $ANSIBLE_ARGS site.yml --skip-tags TAG1,TAG2`

Run specific host group.

`ansible-playbook $ANSIBLE_ARGS site.yml -l HOSTGROUP`



### Terraform

Before running the terraform config, make sure to fetch API tokens (or credentials) for the following services:

* Authentik
* Azure

#### Init Project (Authentik)

```bash
cd terraform/authentik
terraform init

echo 'domain_name = [DOMAIN NAME]' > terraform.tfvars
export AUTHENTIK_URL=[URL]
export AUTHENTIK_TOKEN=[API TOKEN]
```

#### Init Project (Azure)

```bash
cd terraform/azure
terraform init

az login
```

#### Development

```bash
terraform fmt && terraform validate
terraform plan # or terraform apply
```


### SSH Tunnel

Access the test environment services via `localhost`:

```bash
ssh -N -L 8080:localhost:80 ansible@[TEST HOST]
```

Services are then available at `http://SERVICE.localhost:8080`, e.g. `http://home.localhost:8080`.

### Backups

#### Restore Authentik Database
```bash
DOCKER_CONTAINER='authentik-db'
DB_USER=''
DB_NAME='authentik'
docker exec -i "$DOCKER_CONTAINER" psql -U "$DB_USER" "$DB_NAME" < /path/to/authentik-dump.sql
```
