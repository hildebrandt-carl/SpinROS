#include "ros/ros.h"
#include "sample_package/ExampleMessage.h"
#include "stdint.h"
#include <memory>

class Node_sample_package {
private:
	//A smart pointer to the node handle
	ros::NodeHandle nh;
	//The frequency of the loop
	ros::Rate 20;	//Hertz

	char inData ;

	//Subscribers
	ros::Subscriber exampleSub;

	void exampleCallback(const std_msgs::char& msg)
	{
		inData = data ;
		ROS_INFO("Recieved %c", data);
	}

public:
	theSubscriber(): rosRate(20.0)
	{
		exampleSub = nh.subscribe("a", 100, &Node_sample_package::exampleCallback, this);
	}

	int main() {
		//Periodic loop
		while (ros::ok()) 
		{
			ros::spinOnce();
			rosRate.sleep();
		}
		return 0;
	}
};

//Main function
int main(int argc, char **argv)
{
	ros::init(argc, argv, "theSubscrber");
	Node_sample_package node;
	return node.main();
}