#!/usr/bin/env bash
# prepare-dev-linux.sh
# Copy build resources into the source tree

DOCKER_CMD=$(which docker)

if [ ! $DOCKER_CMD ]; then
    echo "Please install Docker then run this script again"
    echo "See: https://www.docker.com/"
    exit -1
fi

# download the latest ScorpioStation image from Docker Hub
docker pull scorpiostation/scorpio:latest

# create a ScorpioStation container to copy files from
docker create --name delete_me scorpiostation/scorpio:latest

# copy build resources from container to code folders
docker cp delete_me:/scorpio/tgui/packages/tgui/public/tgui.bundle.css tgui/packages/tgui/public/tgui.bundle.css
docker cp delete_me:/scorpio/tgui/packages/tgui/public/tgui.bundle.js tgui/packages/tgui/public/tgui.bundle.js
docker cp delete_me:/scorpio/nano/images/Emerald_nanomap_z1.png nano/images/Emerald_nanomap_z1.png

# remove the ScorpioStation container
docker rm delete_me
