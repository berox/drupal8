#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[uri]"
USAGE_ADDITIONAL_HELP="\turi : the Drupal site URI, default is default\n"

source scripts/_environment.sh
source scripts/_ansible.sh

FOLDER_NAME=default
if [ ! -z $2 ]
  then FOLDER_NAME=$2
fi

if [ ! -z $3 ]
  then URI=$3
else
  echo "Missing argument: URI."
  usage
  exit 1
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/setup-upgrade.yml -i provisioning/inventory/$inventory -e script_uri=$URI -e script_folder_name=$FOLDER_NAME
