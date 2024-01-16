ARG ROS_DISTRO=humble

FROM osrf/ros:${ROS_DISTRO}-desktop

RUN apt-get update
RUN apt-get install -y lsb-release wget gnupg

# Install Nav2
RUN apt-get install -y ros-${ROS_DISTRO}-navigation2 ros-${ROS_DISTRO}-nav2-bringup ros-${ROS_DISTRO}-turtlebot3-gazebo && \
    rm -rf /var/lib/apt/lists/*

# Install Gazebo Fortress
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && \
    apt-get install -y ignition-fortress && \
    rm -rf /var/lib/apt/lists/*

# Create Workspace
RUN mkdir -p /ros2_ws/src
WORKDIR /ros2_ws

RUN git clone https://github.com/Yun-Zou/ElementRobotics ./src/robot_node && cd src && colcon build

# Change default shell to Bash
SHELL [ "/bin/bash", "-l", "-c" ]
RUN echo "source /ros2_ws/src/install/setup.bash" >> /root/.bashrc
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
RUN echo "export TURTLEBOT3_MODEL=waffle" >> /root/.bashrc
RUN echo "export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/humble/share/turtlebot3_gazebo/models" >> /root/.bashrc

COPY launchNav.sh /launchNav.sh
COPY launchWorld.sh /launchWorld.sh
RUN chmod +x /launchWorld.sh
RUN chmod +x /launchNav.sh