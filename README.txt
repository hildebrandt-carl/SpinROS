-------------------------------------------------------
*******************Running SPIN************************
-------------------------------------------------------

----------------------------------
            About:
----------------------------------
Spin was installed on Ubuntu 17.10

Installing SPIN can be done using the instructions found on:
http://spinroot.com/spin/Man/README.html


----------------------------------
      Running the model:
----------------------------------
cd Spin

----Proving property 1:----
spin -run property1.pml

----Proving property 2:----
spin -run propery2_noqueue.pml

--You can the do a single iteration using the follow command--
spin -u5000 property2_noqueue.pml

--Showing property 2 with a queue--
spin -run property2_queue.pml

--You can the do a single iteration using the follow command--
spin -u5000 property2_queue.pml

----Proving property 3:-----
spin -run property3.pml

--You can do a single itteration using the following command--
spin -u5000 property3.pml


-------------------------------------------------------
*******************Running ROS*************************
-------------------------------------------------------

----------------------------------
            About:
----------------------------------
ROS's kinetic was installed on Ubuntu 16.04

Installing ROS can be done using the instructions found on:
http://wiki.ros.org/ROS/Installation


----------------------------------
      Running ROS code:
----------------------------------

--Sourcing ROS--
source /opt/ros/kinetic

cd ROS_WS

--To Run ROS--
catkin_make

source devel/setup.bash

--Running the code--
roslaunch ros_verification ros_equivalent.launch
roslaunch ros_verification ros_faster.launch 
roslaunch ros_verification ros_multiplePublishers.launch 
