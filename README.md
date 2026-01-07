
# Homelab

### Templates
The directory `templates` contains config file templates essential to run the services in the ansible playbooks.

Copy the configs: `cp -r templates runtime`



### Ansible

#### Vault
Create an ansible vault file to store secrets.

```bash
ansible-vault create runtime/prod_secrets.yml
ansible-vault create runtime/test_secrets.yml
```

Note: The templates directory contains a sample secrets file.

Run using vault secrets (with vault password file):

```bash
ANSIBLE_ARGS_PROD='-i inventories/prod/hosts.yml --vault-password-file runtime/prod_vault_pass.txt -e@runtime/prod_secrets.yml'
ANSIBLE_ARGS_TEST='-i inventories/test/hosts.yml --vault-password-file runtime/test_vault_pass.txt -e@runtime/test_secrets.yml'
ansible-playbook $ANSIBLE_ARGS_ENV site.yml
```

Run using vault secrets (with vault password prompt):

```bash
ANSIBLE_ARGS_PROD='-i inventories/prod/hosts.yml --ask-vault-password -e@runtime/prod_secrets.yml'
ANSIBLE_ARGS_TEST='-i inventories/test/hosts.yml --ask-vault-password -e@runtime/test_secrets.yml'
ansible-playbook $ANSIBLE_ARGS_ENV site.yml
```

#### Useful Commands

List of available tags.

`ansible-playbook site.yml --list-tags`

List of available tasks.

`ansible-playbook site.yml --list-tasks`

List of hosts.

`ansible-playbook $ANSIBLE_ARGS_ENV site.yml --list-hosts`

Run specific tags.

`ansible-playbook $ANSIBLE_ARGS_ENV site.yml --tags TAG1,TAG2`

Skip specific tags.

`ansible-playbook $ANSIBLE_ARGS_ENV site.yml --skip-tags TAG1,TAG2`

Run specific host group.

`ansible-playbook $ANSIBLE_ARGS_ENV site.yml -l HOSTGROUP`



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



### Packer

```bash
cd packer
packer init .

touch ubuntu.pkrvars.hcl
export PROXMOX_URL=[URL]
export PROXMOX_TOKEN=[API TOKEN]

packer build --var-file=ubuntu.pkrvars.hcl ubuntu-2404-server.pkr.hcl
```

```bash
packer fmt . && packer validate --var-file=ubuntu.pkrvars.hcl .
packer build --var-file=ubuntu.pkrvars.hcl ubuntu-2404-server.pkr.hcl
```
