# ElementRobotics

## How to Run
1. Pull this repo to your local computer
2. `docker build -t element-robotics .`
3. `./start.sh`
5. `./shutdown.sh` Once you're done

# For development
Run the start_development.sh script which will mount the volume instead

## Design Choices
- Chose to closely follow the nav2 examples and use their turtlebot3 model and world while running their nav/slam stack. 
- For the inputs, we get coords and rotation in 2D space from stdin input and pass that to the nav2 simple commander module to request waypoints for the robot to follow.

## Limitations and More Work
- Didn't manage to get automated tests working, however, I would test 
- Path checking hasn't been implemented yet (i.e. Is the destination valid?), would check the path generated from nav2 to determine if it is viable
- Randomised gazebo worlds