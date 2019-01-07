#!/bin/bash

function usage() {
    printf "\n"
    printf "Usage:\n$0 [environment] ${USAGE_ADDITIONAL_PARAMETER}\n"
    printf "\tenvironment : [lxc,inte,staging,preprod,prod]\n"
    printf "${USAGE_ADDITIONAL_HELP}"
    printf "\n"
    exit 0
}

if [ "$1" == "-h" ] ; then
    usage
fi

if [ -z $1 ]
  then usage
fi

case "$1" in
    lxc)
        inventory="lxc"
        ;;
    inte)
        inventory="inte"
        ;;
    staging)
        inventory="staging"
        ;;
    preprod)
        inventory="preprod"
        ;;
    prod)
        inventory="prod"
        ;;
    *)
        echo "No environment $1"
        exit 1
        ;;
esac