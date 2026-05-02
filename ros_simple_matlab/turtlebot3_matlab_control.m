% A collect odometry data from gazebo turtlebot3 
% constract a path in matlab

close all
clear
clc

open('exampleHelperGet2DPose')

% Set environment variables for Fast DDS Discovery Server
ROS_DOMAIN_ID = 0;
setenv("ROS_DOMAIN_ID", num2str(ROS_DOMAIN_ID))
setenv("RMW_IMPLEMENTATION", "rmw_fastrtps_cpp")
setenv("ROS_DISCOVERY_SERVER", "192.168.1.84:11811")

%Create a ROS 2 node. Subscribe to the odometry topic that is bridged from ROS 1.
mat_node = ros2node("/data_mat_node", ROS_DOMAIN_ID);
handles.odomSub = ros2subscriber(mat_node,"/odom","nav_msgs/Odometry");

%Receive the odometry messages from the bridge and use the exampleHelperGet2DPose function 
% to unpack the message into a 2D pose. Get the start position of the robot.
odomMsg = receive(handles.odomSub);
poseStart = exampleHelperGet2DPose(odomMsg);
handles.poses = poseStart;

% Create a publisher for controlling the robot velocity. 
% The bridge takes these messages and sends them on the ROS 1 network.
handles.velPub = ros2publisher(mat_node,'/cmd_vel','geometry_msgs/Twist');

% Run the exampleHelperROS2TurtleBotKeyboardControl function, 
% which allows you to control the TurtleBot3 with the keyboard
poses = exampleHelperROS2TurtleBotKeyboardControl(handles);
