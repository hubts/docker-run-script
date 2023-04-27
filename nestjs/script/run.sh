#!/bin/bash

SCRIPT_DIR=$(dirname $0)
RUN_DIR=$(dirname $SCRIPT_DIR)

# Print current branch
git_branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "> Current branch: [ $git_branch ]"

# Get app information from package.json
APP_NAME=$(node -p "require('$RUN_DIR/package.json').name")
APP_VERSION=$(node -p "require('$RUN_DIR/package.json').version")
IMAGE_FULLNAME="$APP_NAME:$APP_VERSION"

# Build image
echo "> Try to find [ $IMAGE_FULLNAME ] image..."
existing_image=$(docker images | grep -w "$APP_NAME" | grep -w "$APP_VERSION")
if [ -z "$existing_image" ]; then
    echo "> [ $IMAGE_FULLNAME ] build started"

    docker build --rm -t $IMAGE_FULLNAME $RUN_DIR
    [[ $? != 0 ]] && echo "> Build failed" && exit 1
    echo "> Successfully built [ $IMAGE_FULLNAME ] image"

fi
echo "> Successfully found [ $IMAGE_FULLNAME ] image"

# Stop the previous running container
CONTAINER_NAME="$APP_NAME"
previous=$(docker ps -qa --filter "name=$CONTAINER_NAME" | grep -q . && docker stop $CONTAINER_NAME && docker rm -fv $CONTAINER_NAME)
[ ! -z "$previous" ] && echo "> Previous container cleaned"

# Inject environment variables
ENV_FILE="$RUN_DIR/.env"
[ ! -f "$ENV_FILE" ] && echo "> No such environment file" && exit 1
source $ENV_FILE

# Run
docker run -dit \
    --cpus=2 \
    --name=$APP_NAME \
    -p 8000:$PORT \
    --env-file $ENV_FILE \
    $IMAGE_FULLNAME
(( $? == 0 )) && echo "> Successfully started [ $IMAGE_FULLNAME ]"

# Clean legacy images
legacy_images=$(docker images --filter "before=$IMAGE_FULLNAME" --filter=reference="$APP_NAME:*" -q)
if [ ! -z "$legacy_images" ]; then
    docker rmi -f $legacy_images
    if (( $? == 0)); then
        echo "$legacy_images"
        echo "> Legacy images cleaned"
    else
        echo "> Stop the running container to delete all legacy images"
    fi
else
    echo "> Images before [ $IMAGE_FULLNAME ] have been cleaned"
fi

docker image prune -f
echo "> Dangling images cleaned"