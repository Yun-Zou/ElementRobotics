#!/usr/bin/env python
import sys, select, os
import tty, termios
import math

import rclpy
from rclpy.duration import Duration
from rclpy.node import Node

from geometry_msgs.msg import PoseStamped
from nav2_simple_commander.robot_navigator import BasicNavigator, TaskResult

settings = termios.tcgetattr(sys.stdin)

def main(args=None):
    rclpy.init(args=args)

    navigator = BasicNavigator()


    waypoint = []
    print("Only input integer numbers")

    for num in range(1,4):
        x = float(input("Input x coordinate for waypoint " + str(num) + ": "))
        y = float(input("Input y coordinate for waypoint " + str(num) + ": "))
        degrees = float(input("Input degrees for waypoint " + str(num) + ": "))
        waypoint.append([x,y,degrees])
        print("------------------------")

    print("Waypoints")
    print(waypoint)
    print("\nf = Stop the robot at any time\n")

    navigator = BasicNavigator()

    # Set our demo's initial pose
    initial_pose = PoseStamped()
    initial_pose.header.frame_id = 'map'
    initial_pose.header.stamp = navigator.get_clock().now().to_msg()
    initial_pose.pose.position.x = -2.00
    initial_pose.pose.position.y = -0.5
    initial_pose.pose.orientation.z = 0.0
    initial_pose.pose.orientation.w = 0.0
    navigator.setInitialPose(initial_pose)

    # set our demo's goal poses to follow
    goal_poses = []

    for num in range(0,3):
        goal_pose = PoseStamped()
        goal_pose.header.frame_id = 'map'
        goal_pose.header.stamp = navigator.get_clock().now().to_msg()
        goal_pose.pose.position.x = waypoint[num][0]
        goal_pose.pose.position.y = waypoint[num][1]
        goal_pose.pose.orientation.z = math.radians(waypoint[num][2])
        goal_poses.append(goal_pose)
    
    # sanity check a valid path exists
    # path = navigator.getPath(initial_pose, goal_pose1)

    nav_start = navigator.get_clock().now()
    navigator.followWaypoints(goal_poses)

    i = 0
    while not navigator.isTaskComplete():
        ################################################
        #
        # Implement some code here for your application!
        #
        ################################################

        # Check for escape key
        key = getKey()  
        if key == 'f':
            print("Close the app")
            navigator.lifecycleShutdown()
            exit(0)

        # Do something with the feedback
        i = i + 1
        feedback = navigator.getFeedback()
        if feedback and i % 5 == 0:
            print(
                'Executing current waypoint: '
                + str(feedback.current_waypoint + 1)
                + '/'
                + str(len(goal_poses))
            )
            now = navigator.get_clock().now()

            # Some navigation timeout to demo cancellation
            if now - nav_start > Duration(seconds=600.0):
                navigator.cancelTask()


    # Do something depending on the return code
    result = navigator.getResult()
    if result == TaskResult.SUCCEEDED:
        print('Goal succeeded!')
    elif result == TaskResult.CANCELED:
        print('Goal was canceled!')
    elif result == TaskResult.FAILED:
        print('Goal failed!')
    else:
        print('Goal has an invalid return status!')

    navigator.lifecycleShutdown()

    exit(0)


if __name__=="__main__":
    main()

def getKey():
    tty.setraw(sys.stdin.fileno())
    rlist, _, _ = select.select([sys.stdin], [], [], 0.1)
    if rlist:
        key = sys.stdin.read(1)
    else:
        key = ''

    termios.tcsetattr(sys.stdin, termios.TCSADRAIN, settings)
    return key