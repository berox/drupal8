#!/usr/bin/env bash
#####################################################################################
# Script to assist you in the upgrade of an existing Drupal 8 architecture skeleton #
#####################################################################################

# Some colors
RESET="$(tput sgr0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="$(tput setaf 3)"
BLUE="$(tput setaf 4)"

# This script is in architecture/scripts
cd "$( dirname "${BASH_SOURCE[0]}" )"

# Back to the project root path
cd ../../

echo -n "${GREEN}"
echo "======================================================"
echo "= Script to assist you updating an existing skeleton ="
echo "======================================================"
echo "${RESET}"

# Git infos about the architecture skeleton
ARCHITECTURE_GIT_URL="git@git.smile.fr:drupal/drupal8-architecture-skeleton.git"
ARCHITECTURE_GIT_BRANCH="master"
ARCHITECTURE_TMP_FOLDER="/tmp/drupal8_architecture_skeleton_$(date +"%s")"

function clean
{
    echo -n "Cleaning tmp files..."
    rm -rf ${ARCHITECTURE_TMP_FOLDER}
    echo -n " ${GREEN}Done${RESET}"
    echo ""
}

function compare_vars()
{
    #-y --left-column
    #diff -d <(grep -rPoh "^\K([a-zA-Zi_]+):" ${ARCHITECTURE_TMP_FOLDER}/architecture/provisioning/inventory/ | sed -e "s/://"| sort | uniq) \
    #        <(grep -rPoh "^\K([a-zA-Zi_]+):" architecture/provisioning/inventory/ | sed -e "s/://"| sort | uniq)

    new_vars=$(grep -Fxv -f  <(grep -rPoh "^\K([a-zA-Zi_]+):" $1 | sed -e "s/://"| sort | uniq) \
                             <(grep -rPoh "^\K([a-zA-Zi_]+):" $2 | sed -e "s/://"| sort | uniq)
              )
    echo "${new_vars[@]}"
}


# Extract new skeleton
echo -n "Export the architecture files from GIT..."
if [ -d "${ARCHITECTURE_TMP_FOLDER}" ]; then
    rm -rf ${ARCHITECTURE_TMP_FOLDER}
fi
git clone -b ${ARCHITECTURE_GIT_BRANCH} ${ARCHITECTURE_GIT_URL} ${ARCHITECTURE_TMP_FOLDER} > /dev/null 2>&1
if [ $? -ne 0 ]; then
     echo -n " ${RED}KO${RESET}"
     echo " ${RED}ERROR: git clone from ${ARCHITECTURE_GIT_URL} not succeed, check you key${RESET}"
     exit 1
else
    echo -n "${GREEN}Done${RESET}"
fi
echo ""

# Read skeleton version
#cat architecture/VERSION

# Backup inventory
echo -n "Backuping current architecture skeleton..."
BACKUP_DIR=backup/backup_$(date +"%Y%m%d%H%M%S")
mkdir -p $BACKUP_DIR
cp -pr architecture architecture/provisioning/inventory  $BACKUP_DIR
echo -n "${GREEN}Done${RESET}"
echo ""

# Warn on difference on task and inventory new vars with a diff
echo "${RED}==========================================================================="
echo "WARNING: If you have custom tasks in ansible, they will be overriden !"
echo "===========================================================================${RESET}"
read -p "Do you want to override the current skeleton (Y/N) ? ${GREEN}" override
echo -n "${RESET}"

override=$(echo ${override} | tr 'A-Z' 'a-z')
if [ "${override}" != "y" -a "${override}" != "n" ]; then
    echo "  ${RED}You must choose between [Y] or [N]${RESET}"
    exit 1
fi

if [ "${override}" == "y" ]; then
  echo -n "Preparing the folders..."
  
  rm -rf ${ARCHITECTURE_TMP_FOLDER}/.git
  chmod +x ${ARCHITECTURE_TMP_FOLDER}/architecture/scripts/*
  mv ${ARCHITECTURE_TMP_FOLDER}/CHANGELOG.md ${ARCHITECTURE_TMP_FOLDER}/architecture/CHANGELOG.md
  mv ${ARCHITECTURE_TMP_FOLDER}/drupal/README_not_separated.md ${ARCHITECTURE_TMP_FOLDER}/drupal/README.md
  rm -rf ${ARCHITECTURE_TMP_FOLDER}/drupal/README_separated.md
  
  echo -n "${GREEN}Done${RESET}"
  echo ""
  
  # Compare vars to find new vars
  new_vars=$(compare_vars architecture/provisioning/inventory/ ${ARCHITECTURE_TMP_FOLDER}/architecture/provisioning/inventory/)
  
  # Restore custom inventory into TMP folder
  cp -prf $BACKUP_DIR/inventory/* ${ARCHITECTURE_TMP_FOLDER}/architecture/provisioning/inventory/
  
  # Update skeleton
  echo -n "Upgrading the skeleton..."
  rsync -av --force ${ARCHITECTURE_TMP_FOLDER}/architecture/ ./architecture/ > /dev/null 2>&1
  echo -n "${GREEN}Done${RESET}"
  echo ""
  
  # If new vars are found
  if [ "${new_vars}" != "" ]; then
    echo ""

    # Inject new vars to updated inventory if needed
    # ${ARCHITECTURE_TMP_FOLDER}/architecture/provisioning/inventory/group_vars/all
    vars_to_inject=$(printf '%s\n' "${new_vars[@]}"|sed -e 's/^/#/g'|sed -e 's/$/:/g')
    
    cat << EOF >> architecture/provisioning/inventory/group_vars/all

##########################################################################################################################################
# Update of the skeleton is not finished ! Please read instructions !
# The following vars must be added to your inventory, uncomment and configure
# Example, see: https://git.smile.fr/drupal/drupal8-architecture-skeleton/blob/master/architecture/provisioning/inventory/group_vars/all
##########################################################################################################################################
$vars_to_inject
##########################################################################################################################################
EOF
    #tail -n30 ${ARCHITECTURE_TMP_FOLDER}/architecture/provisioning/inventory/group_vars/all
    
    echo ""
    echo "${RED}============================================================================================================================"
    echo "WARNING !"
    echo "The following vars were added automatically at the end of the file architecture/provisioning/inventory/group_vars/all"
    echo "They must be configured manually ! For configuration, you can take the example at:"
    echo "https://git.smile.fr/drupal/drupal8-architecture-skeleton/blob/master/architecture/provisioning/inventory/group_vars/all"
    echo 
    printf '%s\n' "${new_vars[@]}"
    echo "============================================================================================================================${RESET}"

    echo ""
  fi
else
  clean
  exit 1
fi

# Last cleaning
clean
echo ""
