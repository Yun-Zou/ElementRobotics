#!/bin/bash

docker run \
    --name robot-container \
    -e="DISPLAY=host.docker.internal:0.0" \
    -v /home/yun/.ssh/id_rsa_general:/root/.ssh/id_rsa \
    -v /home/yun/ElementalRobotics:/ros2_ws/src/robot_node \
    -it -d element-robotics

docker exec -it robot-container sh -c "cd src && colcon build"

# docker kill robot-container && docker rm robot-container
echo "Done"