#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[folder_name] [uri] [-h]"
USAGE_ADDITIONAL_HELP=$(cat <<EOF
    folder_name: Drupal subsite folder name.
    uri Drupal site uri.
    -h|--help    This help
EOF
)

EXTRA_VARS=""
INSTALL_MODULES="N"

source scripts/_environment.sh
source scripts/_ansible.sh

# Retrieve params.
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

# Database warning.
echo ""
echo "Launch the install process ?"
echo "   WARNING: it will erase the current database if it already exists"
read -p "   [y,n]: " confirm
echo
confirm=$(echo ${confirm} | tr 'A-Z' 'a-z')
if [ "${confirm}" != "y" ]; then
    echo "  Aborted by user"
    exit 1
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/install.yml -i provisioning/inventory/$inventory -e script_uri=$URI -e script_folder_name=$FOLDER_NAME -e "${EXTRA_VARS}"
