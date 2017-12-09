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

	//Publishers
	ros::Publisher examplePub;

public:
	Node_sample_package()
		: rosRate(20.0)
	{
		examplePub = nh.advertise<sample_package::ExampleMessage>("a", 100);
	}

	int main() {
		//Periodic loop
		while (ros::ok()) 
		{
			//Publish the message
			examplePub.publish('w');
			ros::spinOnce();
			rosRate.sleep();
		}
		return 0;
	}
};

//Main function
int main(int argc, char **argv)
{
	//Create a node	
	ros::init(argc, argv, "thePublisher");
	Node_sample_package node;
	return node.main();
}