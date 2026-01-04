
# Homelab

### Templates
The directory `templates` contains config file templates essential to run the services in the ansible playbooks.

Copy the configs: `cp -r templates runtime`

### Vault
Create an ansible vault file to store secrets.

`ansible-vault create runtime/ansible_secrets.yml`

Edit the become password variables in the `runtime/inventory.yml` file to match the secret names above.

Run using vault secrets (with vault password file):

```bash
ANSIBLE_ARGS='-i runtime/inventory.yml --vault-password-file runtime/vault_pass.txt -e@runtime/ansible_secrets.yml'
ansible-playbook $ANSIBLE_ARGS [PLAYBOOKS]
```

Run using vault secrets (with vault password prompt):

```bash
ANSIBLE_ARGS='-i runtime/inventory.yml --ask-vault-password -e@runtime/ansible_secrets.yml'
ansible-playbook $ANSIBLE_ARGS [PLAYBOOKS]
```

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
