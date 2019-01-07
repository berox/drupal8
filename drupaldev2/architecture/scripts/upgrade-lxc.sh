#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

ansible-playbook provisioning/composer-install.yml -i provisioning/inventory/lxc
ansible-playbook provisioning/upgrade-lxc.yml -i provisioning/inventory/lxc
