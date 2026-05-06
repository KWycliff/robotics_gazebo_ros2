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
1.launch the turtlebot in the gazebo simulation world
2.create ros2_gazebo bridge 
ros2 run ros_gz_bridge parameter_bridge /scan@sensor_msgs/msg/LaserScan@gz.msgs.LaserScan
ros2 run ros_gz_bridge parameter_bridge /odom@nav_msgs/msg/Odometry@gz.msgs.Odometry
3.accertain that the scan and odom topics are visible
4.record the data from these topics using the ros2 record: ros2 bag record -s mcap /scan /odom /tf /tf_static
5.use the mcap map format
6.convert to a .bag file which can be read by the slam map builder in matlab:rosbags-convert --src ./montecarlo/rosbag2_2026_04_09-18_13_12/ --dst ./montecarlo/rosbag2_2026_04_09-18_13_12/turtleworld.bag
7.save the recovered map
this map can be used for montecarlo localisation projects
and the slam algorithms.

for gazebo simulation word, here is the bridge:
Odometry
ros2 run ros_gz_bridge parameter_bridge \
  /model/tugbot/odometry@nav_msgs/msg/Odometry[gz.msgs.Odometry \
  --ros-args -r /model/tugbot/odometry:=/odom

Scan 
ros2 run ros_gz_bridge parameter_bridge \
  /world/world_demo/model/tugbot/link/scan_omni/sensor/scan_omni/scan@sensor_msgs/msg/LaserScan[gz.msgs.LaserScan \
  --ros-args -r /world/world_demo/model/tugbot/link/scan_omni/sensor/scan_omni/scan:=/scan
