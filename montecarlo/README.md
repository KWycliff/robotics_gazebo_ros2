steps to setup the gazebo environment
1.open the discovery server: fastdds discovery --server-id
2.export RMW_implementation: export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
3.export the ROS_id: export ROS_DOMAIN_ID=0
4.export the ip_addr to be visible on the network: export ROS_DISCOVERY_SERVER=192.168.1.84:11811 
5.source the turtlebot3
6.export the turtle model:export TURTLEBOT3_MODEL=waffle
7.launch the turtlebot in gazebo: ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py 
8.run the montecarlo.mat script


creating a map using the matlab slam map builder
launch the turtlebot in the gazebo simulation world
accertain that the scan and odom topics are visible 
record the data from these topics using the ros2 record
use the mcap map format
convert to a .bag file which can be read by the slam map builder in matlab 
save the recovered map
this map can be used for montecarlo localisation projects
and the slam algorithms.  


