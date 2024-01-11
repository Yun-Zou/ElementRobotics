#!/bin/bash

docker run \
    -env="DISPLAY=host.docker.internal:0.0" \
    -it elemental-robotics
    
echo "Done"