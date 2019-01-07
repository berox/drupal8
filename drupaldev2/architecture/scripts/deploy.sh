#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ..

USAGE_ADDITIONAL_PARAMETER="[-p PreGeneratedPackage] [-b VCSBranch] [-t VCSTag] [-f] [-h]"
USAGE_ADDITIONAL_HELP=$(cat <<EOF
    -p : Specify a generated package version to deliver
    -b : Specify a VCS branch to deliver
    -t : Specify a VCS tag to deliver
    -f : First deployment
    -h : This help
EOF
)

DEPLOY_NAME="";
EXTRA_VARS=""
BUILD_EXTRA_VARS=""

source scripts/_environmentnotlxc.sh
source scripts/_ansible.sh

if [ -z $2 ]
  then usage
fi

# Retreive params
OPTIND=2
while getopts "p:b:t:sfh" VARNAME; do
    case $VARNAME in
        h)
            usage
            ;;
        p)
            PACKAGE="$OPTARG"
            ;;
        b)
            BRANCH="$OPTARG"
            ;;
        t)
            TAG="$OPTARG"
            ;;
        f)
            FIRST_DEPLOYMENT="Y"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
    esac
done

# Check that options are valid
if [ -z "${PACKAGE}" ] && [ -z "${BRANCH}" ] && [ -z "${TAG}" ]; then
    echo "ERROR: You must precise a package or a branch or a tag to deliver"
    exit 1;
fi

if [ "${BRANCH}" != "" ] && [ "${TAG}" != "" ]; then
    echo "ERROR: You cannot use -b and -t together"
    exit 1;
fi

# Prepare vars to pass to playbooks.
if [ "${BRANCH}" != "" ]; then
    DEPLOY_NAME="${BRANCH}-`date +%Y%m%d%H%M`"
    BUILD_EXTRA_VARS="branch=${BRANCH}"
elif [ "${TAG}" != "" ]; then
    DEPLOY_NAME="${TAG}"
    BUILD_EXTRA_VARS="tag=${TAG}"
else
    DEPLOY_NAME="${PACKAGE}"
fi

if [ "${FIRST_DEPLOYMENT}" == "Y" ]; then
    EXTRA_VARS="${EXTRA_VARS} first_deployment=Y"
fi

BUILD_EXTRA_VARS="deploy_version=${DEPLOY_NAME} ${BUILD_EXTRA_VARS}"
EXTRA_VARS="deploy_version=${DEPLOY_NAME} ${EXTRA_VARS}"

# Run playbooks.
ansible-playbook provisioning/generate-package.yml -i provisioning/inventory/local -e "${BUILD_EXTRA_VARS}"
ansible-playbook --ssh-extra-args="${ANSIBLE_SSH_ARGS}" provisioning/deploy.yml -i provisioning/inventory/$inventory -e "${EXTRA_VARS}"
