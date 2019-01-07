#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="phpunit_arguments"
USAGE_ADDITIONAL_HELP="\tphpunit_arguments: arguments passed to PHPUnit command."

source scripts/_environment.sh
source scripts/_ansible.sh

if [ ! -z $2 ]
  then PHPUNIT_ARGUMENTS=$2
else
  echo "Missing PHPUnit arguments."
  usage
  exit 1
fi

ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/run-tests-phpunit.yml -i provisioning/inventory/$inventory -e "phpunit_arguments=$PHPUNIT_ARGUMENTS"
