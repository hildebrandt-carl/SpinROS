#include "ros/ros.h"
#include "std_msgs/String.h"
#include "sample_package/ExampleMessage.h"
#include "stdint.h"
#include <memory>

class Node_sample_package {
private:
	//A smart pointer to the node handle
	ros::NodeHandle nh;
	//The frequency of the loop
	ros::Rate rosRate;	//Hertz

	//Parameters
	std::string stringParam;
	int intParam;
	double doubleParam;
	bool boolParam;

	//Publishers
	ros::Publisher examplePub;
	//Subscribers
	ros::Subscriber exampleSub;

	//Callback function
	std::string receivedString = "";
	void exampleCallback(const std_msgs::String::ConstPtr& msg)
	{
		receivedString = msg->data;
	}

public:
	//Constructor
	Node_sample_package()
		: rosRate(20.0)
	{
		//Get Parameters
		nh.param<std::string>("/" + ros::this_node::getName() + "/stringParam", stringParam, "defaultValue");
		nh.param<int>("/" + ros::this_node::getName() + "/intParam", intParam, 0);
		nh.param<double>("/" + ros::this_node::getName() + "/doubleParam", doubleParam, 0.0);
		nh.param<bool>("/" + ros::this_node::getName() + "/boolParam", boolParam, false);

		//Set up publishers and subscribers
		examplePub = nh.advertise<sample_package::ExampleMessage>("examplePub", 100);
		exampleSub = nh.subscribe("exampleSub", 100, &Node_sample_package::exampleCallback, this);

		//Other one-time code here.
	}

	int main() {
		//Periodic loop
		while (ros::ok()) {			//While we haven't shutdown

			//Periodic code here

			//Example: Construct a message
			sample_package::ExampleMessage exampleMessage;

			exampleMessage.header.stamp = ros::Time::now();
			exampleMessage.intField = intParam;
			exampleMessage.doubleField = doubleParam;
			exampleMessage.stringField = receivedString;
			exampleMessage.boolField = boolParam;

			//Publish the message
			examplePub.publish(exampleMessage);

			ros::spinOnce();	//Handle callbacks
			rosRate.sleep();	//Sleep until next iteration
		}

		return 0;
	}
};


//Main function
int main(int argc, char **argv)
{
	//Create a node	
	ros::init(argc, argv, "sample_package_node_default_name");	//Default name, used if name is not specified by launch file
	Node_sample_package node;
	return node.main();
}