#!/bin/bash

docker run \
    --name robot-container \
    -e="DISPLAY=host.docker.internal:0.0" \
    -it -d element-robotics

docker exec -it robot-container /bin/bash -l -i "/launchWorld.sh"

docker kill robot-container && docker rm robot-container
echo "Done"