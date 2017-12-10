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

	int counter ;

public:
	publisher_class()
		: rosRate(20.0)
	{
		examplePub = nh.advertise<std_msgs::String>("a", 2);
		counter = 0;
	}

	int main() {
		//Periodic loop
		while (ros::ok()) 
		{
			//Publish the message
			std_msgs::String msg;			
			std::stringstream ss;
			ss << "a " << counter;

			counter++ ;

			msg.data = ss.str();
			
			examplePub.publish(msg);
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
	ros::init(argc, argv, "thePublisherNode1");
	publisher_class node;
	return node.main();
}