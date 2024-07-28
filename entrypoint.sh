#!/bin/bash

set -e
# path to the directory where the project will be cloned
PATH="/srv/hngprojects"
CONTAINER_NAME="${BRANCH_NAME}_${PR_NUMBER}_container"
echo "Starting deployment 1..."

# apt install sshpass
# sshpass -p $SERVER_PASSWORD ssh -o StrictHostKeyChecking=no -p $SERVER_PORT $SERVER_USERNAME@$SERVER_HOST <<EOF
#   echo "Starting deployment 2..."
#   mkdir -p /root/chinonso
# EOF
echo "Deployment script executed."
