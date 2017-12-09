#include "ros/ros.h"
#include "std_msgs/String.h"
#include "stdint.h"

class publisher_class {
private:
	//A smart pointer to the node handle
	ros::NodeHandle nh;
	//The frequency of the loop
	ros::Rate rosRate;	//Hertz

	//Publishers
	ros::Publisher examplePub;

public:
	publisher_class()
		: rosRate(20.0)
	{
		examplePub = nh.advertise<std_msgs::String>("a", 100);
	}

	int main() {
		//Periodic loop
		while (ros::ok()) 
		{
			//Publish the message
			std_msgs::String str;
			str.data = "w";
			examplePub.publish(str);
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
	publisher_class node;
	return node.main();
}