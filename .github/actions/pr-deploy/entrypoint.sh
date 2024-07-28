#!/bin/bash

set -e
# path to the directory where the project will be cloned
PATH="/srv/hngprojects"
CONTAINER_NAME="${BRANCH_NAME}_${PR_NUMBER}_container"
echo "Starting deployment..."

# apt install sshpass
sshpass -p $SERVER_PASSWORD ssh -o StrictHostKeyChecking=no -p $SERVER_PORT $SERVER_USERNAME@$SERVER_HOST << EOF
  echo "Cloning the repository..."
  # if [ -d "$DIR" ]; then
  #   rm -rf $DIR
  # fi
  sudo mkdir -p "/srv/hngprojects"
  git clone $REPO_URL $PATH
  cd $PATH
  PROJECT_NAME=\$(basename -s .git \$REPO_URL)
  cd $PROJECT_NAME

  # echo "Checking for existing container..."
  # if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
  #   echo "Stopping and removing existing container..."
  #   docker rm -f $CONTAINER_NAME
  # fi

  if [[ ! -d "$DIR" ]]; then
    echo "Directory not found: $DIR, please check the directory path."
    exit 1
  fi

  cd $DIR
  if [ -n "$DOCKERFILE" ]; then
      if [ ! -f "$DOCKERFILE" ]; then
        echo "Dockerfile not found in the specified path: $DOCKERFILE"
        exit 1;
      fi
    docker build -t $CONTAINER_NAME -f $DOCKERFILE 2>&1
    docker run -d --name $CONTAINER_NAME -p $EXPOSED_PORT:$EXPOSED_PORT --env $ENV_VARS $CONTAINER_NAME 2>&1
  elif [[ -n "$COMPOSE_FILE" ]]; then
    if [ ! -f "$COMPOSE_FILE" ]; then
        echo "Docker compose file not found in the specified path: $COMPOSE_FILE"
        # echo "success" >> $GITHUB_OUTPUT
        exit 1;
    fi
    echo "docker-compose.yml detected. Building and deploying using Docker Compose..."
    docker-compose down 2>&1
    docker-compose up -d --build 2>&1
  else
    echo "No Dockerfile or docker-compose.yml found. Running start command..."
    $($START_COMMAND 2>&1)
    exit 1
  fi

  echo "Deployment completed. Container name: $CONTAINER_NAME"
  echo "Container status:"
  docker ps -f name=$CONTAINER_NAME 2>&1

  echo "Fetching container logs..."
  docker logs $CONTAINER_NAME 2>&1
EOF
echo "Deployment script executed."
