#!/bin/bash

set -e
# path to the directory where the project will be cloned
PATH="/srv/hngprojects"
CONTAINER_NAME="${BRANCH_NAME}_${PR_NUMBER}_container"
echo "Starting deployment..."

# apt install sshpass
echo "Cloning the repository..."
if [ -d "$DIR" ]; then
  rm -rf $DIR
fi
sudo mkdir -p "/srv/hngprojects"
