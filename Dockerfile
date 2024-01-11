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
RUN mkdir -p ~/ros_ws/src
WORKDIR /ros2_ws

RUN git clone https://github.com/Yun-Zou/ElementalRobotics ./src/robot_node


# RUN git clone https://github.com/ros-planning/navigation2.git --branch $ROS_DISTRO ./src/navigation2 && \
#     rosdep install -y \
#     --from-paths ./src \
#     --ignore-src && \
#     colcon build \
#     --symlink-install
# # Install everything needed
# RUN apt-get update --fix-missing && \
#     apt upgrade -y && \
#     apt-get install -y \
#     ros-dev-tools && \
#     # Clone source
#     git clone -b $ROS_DISTRO https://github.com/ros-planning/navigation2.git

# # Install dependencies
# RUN rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
#     rosdep init && \
#     rosdep update --rosdistro $ROS_DISTRO && \
#     rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y &&

# Build
# RUN colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release && \
#     apt install -y \
#     ros-$ROS_DISTRO-navigation2 \
#     ros-$ROS_DISTRO-nav2-bringup && \
#     # Save version
#     echo $(dpkg -s ros-$ROS_DISTRO-navigation2 | grep 'Version' | sed -r 's/Version:\s([0-9]+.[0-9]+.[0-9]+).*/\1/g') > /version.txt && \
#     # Size optimalization
#     rm -rf build log src && \
#     export SUDO_FORCE_REMOVE=yes && \
#     apt-get remove -y \
#     ros-dev-tools && \
#     apt-get autoremove -y && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*