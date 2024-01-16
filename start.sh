#!/bin/bash

docker run \
    --name robot-container \
    -e="DISPLAY=host.docker.internal:0.0" \
    -it -d element-robotics

docker exec -it robot-container bash "/launchWorld.sh"

docker exec -it robot-container bash "/launchNav.sh"

# docker kill robot-container && docker rm robot-container
echo "Done"