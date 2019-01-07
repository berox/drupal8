#!/bin/bash

ANSIBLE_SSH_ARGS="-o UserKnownHostsFile=./known_hosts"
if [ "${inventory}" == "lxc" ]; then
    ANSIBLE_SSH_ARGS=""
fi
