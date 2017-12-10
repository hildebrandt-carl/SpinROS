#include "ros/ros.h"
#include "std_msgs/String.h"
#include "stdint.h"

class subscriber_class {
private:
	//A smart pointer to the node handle
	ros::NodeHandle nh;
	//The frequency of the loop
	ros::Rate rosRate;	//Hertz

	//Subscribers
	ros::Subscriber exampleSub;

	void exampleCallback(const std_msgs::StringConstPtr& msg)
	{
		ROS_INFO("Recieved %s", (msg->data).c_str());
	}

public:
	subscriber_class(): rosRate(20.0)
	{
		exampleSub = nh.subscribe("a", 2, &subscriber_class::exampleCallback, this);
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
	ros::init(argc, argv, "theSubscrberNode");
	subscriber_class node;
	return node.main();
}