#!/bin/bash

docker run \
    -e="DISPLAY=host.docker.internal:0.0" \
    -v /home/yun/.ssh/id_rsa_general:/root/.ssh/id_rsa \
    -it element-robotics
    
echo "Done"