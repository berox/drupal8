#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[uri]"
USAGE_ADDITIONAL_HELP=$(cat <<EOF
    uri Drupal site uri. If no uri is set, it will be applied to all sites.

EOF
)

source scripts/_environment.sh
source scripts/_ansible.sh

ALL_SITES="ALL"
if [ ! -z $2 ] ; then
  URI=$2
  ALL_SITES="N"
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/cache-clean.yml -i provisioning/inventory/$inventory -e script_uri=$URI -e all_sites=$ALL_SITES
