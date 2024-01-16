# ElementRobotics

## How to Run
1. Pull this repo to your local computer
2. `docker build -t element-robotics .`
3. `.start.sh` To start the container and load the world
4. `.run.sh` To start the navigation inputs

# For development
Run the start_development.sh script which will mount the volume instead

## Design Choices
- Problem is asking for a random environment, therefore need to have a SLAM module running.
- Docker will run the gazebo and rviz and display is piped out to local computer so that it remains processing occurs all in the docker
- Chose to closely follow the nav2 examples and use their turtlebot3 model and world while running their nav/slam stack. 
- For the inputs, we get coords and rotation in 2D space from stdin input and pass that to the nav2 simple commander module to request waypoints for the robot to follow.

## Limitations and More Work
- Didn't manage to get automated tests working, however, I would test 
- Path checking hasn't been implemented yet (i.e. Is the destination valid?), would check the path generated from nav2 to determine if it is viable
- Randomised gazebo worlds