#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_environmentnotlxc.sh
source scripts/_ansible.sh

# Run playbooks.
ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/generate-settings.yml -i provisioning/inventory/$inventory
