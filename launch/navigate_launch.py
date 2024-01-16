# Copyright (c) 2021 Samsung Research America
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os

from ament_index_python.packages import get_package_share_directory

from launch import LaunchDescription
from launch.launch_description_sources import PythonLaunchDescriptionSource
from launch.substitutions import LaunchConfiguration
from launch.actions import (
    DeclareLaunchArgument,
    GroupAction,
    IncludeLaunchDescription,
    SetEnvironmentVariable,
)

def generate_launch_description():
    
    turtlebot3_dir  = get_package_share_directory('turtlebot3_gazebo')
    bringup_dir     = get_package_share_directory('nav2_bringup')
    slamtoolbox_dir = get_package_share_directory('slam_toolbox')
    launch_dir = os.path.join(bringup_dir, 'launch')

    slam = LaunchConfiguration('slam')
    headless = LaunchConfiguration('headless')

    # Specify the actions
    bringup_cmd_group = GroupAction(
        [
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource(
                    os.path.join(turtlebot3_dir, 'launch', 'robot_state_publisher.launch.py')
                ),
            ),
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource(
                    os.path.join(bringup_dir, 'launch', 'navigation_launch.py')
                )
            ),
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource(
                    os.path.join(slamtoolbox_dir, 'launch', 'online_async_launch.py')
                ),
            ),
            IncludeLaunchDescription(
                PythonLaunchDescriptionSource(
                    os.path.join(bringup_dir, 'launch', 'tb3_simulation_launch.py')
                ),
                launch_arguments={
                    'slam' : slam,
                    'headless' : headless,
                }.items(),
            ),
        ]
    )

    # Create the launch description and populate
    ld = LaunchDescription([
        DeclareLaunchArgument(
            name= 'slam', default_value='True',
            description='use slam or now'),

        DeclareLaunchArgument(
            name='headless', default_value='False',
            description=''),
    ])

    # Add the actions to launch all of the navigation nodes
    ld.add_action(bringup_cmd_group)

    return ld