#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[status] [uri]"
USAGE_ADDITIONAL_HELP="\tstatus : enable/disable\n\turi : the Drupal site URI."

source scripts/_environment.sh
source scripts/_ansible.sh

if [ ! -z $3 ]
  then URI=$3
else
  echo "Missing argument: URI."
  usage
  exit 1
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/set-maintenance.yml -i provisioning/inventory/$inventory -e "status=$2" -e "script_uri=$URI"
