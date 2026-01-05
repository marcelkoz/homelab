
# Homelab

### Templates
The directory `templates` contains config file templates essential to run the services in the ansible playbooks.

Copy the configs: `cp -r templates runtime`



### Ansible

#### Vault
Create an ansible vault file to store secrets.

`ansible-vault create runtime/ansible_secrets.yml`

Edit the become password variables in the `runtime/inventory.yml` file to match the secret names above.

Run using vault secrets (with vault password file):

```bash
ANSIBLE_ARGS='-i runtime/inventory.yml --vault-password-file runtime/vault_pass.txt -e@runtime/ansible_secrets.yml'
ansible-playbook $ANSIBLE_ARGS site.yml
```

Run using vault secrets (with vault password prompt):

```bash
ANSIBLE_ARGS='-i runtime/inventory.yml --ask-vault-password -e@runtime/ansible_secrets.yml'
ansible-playbook $ANSIBLE_ARGS site.yml
```

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

Before running the terraform config, make sure to fetch API tokens for the following services:

* Authentik

#### Init Project

```bash
cd terraform
terraform init

echo 'domain_name = [DOMAIN NAME]' > terraform.tfvars
export AUTHENTIK_URL=[URL]
export AUTHENTIK_TOKEN=[API TOKEN]

terraform plan
terraform apply
```

#### Development

```bash
terraform fmt && terraform validate
terraform plan
```
