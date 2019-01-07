#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_environment.sh
source scripts/_ansible.sh

ansible-galaxy install -r provisioning/requirements.yml -p provisioning/roles -n -f
ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/provision.yml -i provisioning/inventory/$inventory
