cmake_minimum_required(VERSION 2.8.3)
project(ros_verification)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -w -O3 -std=c++11")

## Find catkin and any catkin packages
find_package(catkin REQUIRED COMPONENTS roscpp rospy std_msgs)

include_directories(include ${catkin_INCLUDE_DIRS})

add_executable(thePublisher src/thePublisher.cpp)
target_link_libraries(thePublisher ${catkin_LIBRARIES})
add_dependencies(thePublisher demo_project_c_generate_messages_cpp)

add_executable(theSubscriber src/theSubscriber.cpp)
target_link_libraries(theSubscriber ${catkin_LIBRARIES})
add_dependencies(theSubscriber demo_project_c_messages_cpp)


