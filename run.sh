#!/bin/bash

docker run \
    --name robot-container \
    -e="DISPLAY=host.docker.internal:0.0" \
    -v /home/yun/.ssh/id_rsa_general:/root/.ssh/id_rsa \
    -v /home/yun/ElementalRobotics:/ros2_ws/src/robot_node \
    -it element-robotics
    
echo "Done"