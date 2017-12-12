Running property1_noqueue.pml
To show that the assertion is violated
spin -run -m10000000 property1_noqueue.pml
To see why you can run
spin -u1000 property1_noqueue. pml


To Run ROS
catkin_build
Then
source devel/setup.bash

Then you can run
roslaunch ros_verification ros_working.launch
roslaunch ros_verification ros_overflow.launch
