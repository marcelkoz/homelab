
`cp -r templates runtime`

**Password Auth**
Password auth: `ansible-playbook -kK -i runtime/inventory.yml [PLAYBOOKS]`

**SSH Key Auth**
SSH key auth: `ansible-playbook -K -i runtime/inventory.yml [PLAYBOOKS]`

**Setup Repos and Docker**
`ansible-playbook -K -i runtime/inventory.yml docker.yml --tags setup,clone`

**Update Docker Images and Restart**
`ansible-playbook -K -i runtime/inventory.yml docker.yml --tags update,build,run`
