
cp -r templates runtime
ansible-playbook -kK -i runtime/inventory.ini playbooks/fedora.yml playbooks/docker.yml
