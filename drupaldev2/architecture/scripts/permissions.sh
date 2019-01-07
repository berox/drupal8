#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

source scripts/_environment.sh
source scripts/_ansible.sh

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/permissions.yml -i provisioning/inventory/$inventory
