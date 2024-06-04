
cp -r templates runtime
Password auth: ansible-playbook -kK -i runtime/inventory.ini fedora.yml docker.yml
SSH key auth: ansible-playbook -K -i runtime/inventory.ini fedora.yml docker.yml
