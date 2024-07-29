#!/bin/bash

set -e
# path to the directory where the project will be cloned
PATH="/srv/hngprojects"
CONTAINER_NAME="${BRANCH_NAME}_${PR_NUMBER}_container"
echo "Starting deployment..."

# apt install sshpass
sshpass -p "$SERVER_PASSWORD" ssh -o StrictHostKeyChecking=no "$SERVER_USERNAME@$SERVER_HOST" << EOF
  echo "Cloning the repository..."
  if [ -d "$DIR" ]; then
    rm -rf $DIR
  fi
  sudo mkdir -p "/srv/hngprojects"
EOF
echo "Deployment script executed."
