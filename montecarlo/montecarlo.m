%----------------------------------------------------
% Real-Time Monte Carlo Localization for TurtleBot3 
% running in the gazebo simulation environment
%-----------------------------------------------------

close all
clear
clc

% Set environment variables for Fast DDS Discovery Server
ROS_DOMAIN_ID = 0;
setenv("ROS_DOMAIN_ID", num2str(ROS_DOMAIN_ID))
setenv("RMW_IMPLEMENTATION", "rmw_fastrtps_cpp")
setenv("ROS_DISCOVERY_SERVER", "192.168.1.84:11811")

% Create a ROS 2 node.
try
    node = ros2node("/matlab_mcl_node");
    disp('ROS 2 Node created successfully.');
catch
    disp('Node already exists or ROS 2 environment is not configured.');
end

% load the turtleworld occupancy myOccMap
mapData = load('turlteword_grid_occupancy.mat');
myOccMap = mapData.myOccMap;
%show(myOccMap);

% Configure the Motion and Sensor Models
%Odometry model
odometryModel = odometryMotionModel;
odometryModel.Noise = [0.2 0.2 0.2 0.2];

% Lidar sensor model
sensorModel = likelihoodFieldSensorModel;
sensorModel.Map = myOccMap;
sensorModel.SensorLimits = [0.12 3.5];

% initialize montecarlo localization object
mcl = monteCarloLocalization;
mcl.UseLidarScan = true;
mcl.MotionModel = odometryModel;
mcl.SensorModel = sensorModel;

mcl.UpdateThresholds = [0.1, 0.1, 0.1]; 
mcl.ResamplingInterval = 1;
mcl.ParticleLimits = [500 5000];
mcl.GlobalLocalization = true;

% subscribe to ros2 topics in gazebo simulation environment
disp('subscribe to the ros2 topics');

odomSub = ros2subscriber(node, "/odom", "nav_msgs/Odometry");

scanSub = ros2subscriber(node, "/scan", "sensor_msgs/LaserScan");

% Wait for the first messages to arrive
disp('Waiting for sensor data from gazebo simulation environment');
receive(odomSub, 10);
receive(scanSub, 10);
disp('Data received! Starting Monte carlo localization');

% Occupancy Map Visualization
figure('Name', 'Monte Carlo Localization', 'NumberTitle', 'off');
ax = axes;
show(myOccMap, 'Parent', ax);
hold(ax, 'on');

plotParticles = scatter(ax, 0, 0, 5, 'r', 'filled'); 
plotEstimatedPose = plot(ax, 0, 0, 'go', 'MarkerSize', 8, 'LineWidth', 2); 
title('TurtleBot3 Localization');
hold(ax, 'off');
%-----------------------------------------------------
% Processing Loop
%-----------------------------------------------------
% Use ros2rate to maintain a steady loop frequency
rate = ros2rate(node, 10); 

while true
    scanMsg = scanSub.LatestMessage;
    odomMsg = odomSub.LatestMessage;
    
    if isempty(scanMsg) || isempty(odomMsg)
        continue;
    end
    
    % Extract Odometry Pose [x, y, theta]
    quat = [odomMsg.pose.pose.orientation.w, ...
            odomMsg.pose.pose.orientation.x, ...
            odomMsg.pose.pose.orientation.y, ...
            odomMsg.pose.pose.orientation.z];
    eul = quat2eul(quat);
    
    currentOdomPose = [odomMsg.pose.pose.position.x, ...
                       odomMsg.pose.pose.position.y, ...
                       eul(1)];
    
    % Extract LiDAR Scan
    angles = (scanMsg.angle_min : scanMsg.angle_increment : scanMsg.angle_max)';
    ranges = double(scanMsg.ranges);  % ensure double precision
    ranges(isinf(ranges) | isnan(ranges)) = 0;
    scan = lidarScan(ranges, angles);
    
    % Step MCL —
    [isUpdated, estimatedPose, particles] = mcl(currentOdomPose, scan);
    
    % Update Visualization
    if isUpdated && ~isempty(particles)
        set(plotParticles, 'XData', particles(:,1), 'YData', particles(:,2));
        set(plotEstimatedPose, 'XData', estimatedPose(1), 'YData', estimatedPose(2));
        drawnow limitrate;
    end
    
    waitfor(rate);
end