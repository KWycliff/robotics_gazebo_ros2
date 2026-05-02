% create a connection between gazebo and matlab on a ros2 network
% create a fast dds server
% export the discovery server to be visible on the entire network: export ROS_DISCOVERY_SERVER=<IP_ADRESS:11811
% start the turtlebot3 in an empty world in gazebo
% open a new terminal
% export the RMW_IMPLEMENTATION=rmw_fastrtps_cpp
% it is necessary so that all nodes on the network use this rmw
% in the same terminal, create a bridge between gazebo and ros2
% in matlab, create a node to subscribe to any desired topic in the gazebo environment

close all
clear
clc

% Set environment variables for Fast DDS Discovery Server
ROS_DOMAIN_ID = 0;
setenv("ROS_DOMAIN_ID", num2str(ROS_DOMAIN_ID))
setenv("RMW_IMPLEMENTATION", "rmw_fastrtps_cpp")
setenv("ROS_DISCOVERY_SERVER", "192.168.1.84:11811")

%pause(5);


% Create subscriber node
%subNode = ros2node("/matlab_sub", ROS_DOMAIN_ID);

node = ros2node("/matlab_node", ROS_DOMAIN_ID);
odom_sub = ros2subscriber(node, "/odom", "nav_msgs/Odometry", @odomCallback);

% Keep MATLAB running
pause(30);  % listen for 30 seconds

function odomCallback(msg)
    x = msg.pose.pose.position.x;
    y = msg.pose.pose.position.y;
    fprintf("x: %.3f, y: %.3f\n", x, y);
end