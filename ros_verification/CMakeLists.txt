cmake_minimum_required(VERSION 2.8.3)
project(ros_verification)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w -O3 -std=c++11")

## Find catkin and any catkin packages
find_package(catkin REQUIRED COMPONENTS roscpp rospy std_msgs)

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(thePublisherNode src/thePublisher.cpp)
target_link_libraries(thePublisherNode ${catkin_LIBRARIES})

add_executable(theSubscriberNode src/theSubscriber.cpp)
target_link_libraries(theSubscriberNode ${catkin_LIBRARIES})


