close all
clear
clc

% Set environment variables for Fast DDS Discovery Server
ROS_DOMAIN_ID = 0;
setenv("ROS_DOMAIN_ID", num2str(ROS_DOMAIN_ID))
setenv("RMW_IMPLEMENTATION", "rmw_fastrtps_cpp")
setenv("ROS_DISCOVERY_SERVER", "192.168.1.84:11811")

% Create subscriber node
subNode = ros2node("/matlab_sub", ROS_DOMAIN_ID);

% Create subscriber - adjust topic name and message type to match your talker
sub = ros2subscriber(subNode, "/chatter", "std_msgs/String", @subscriberCallback);

% Display connection info
fprintf('Listener node created: %s\n', subNode.Name);
fprintf('Subscribed to topic: %s\n', sub.TopicName);
fprintf('Message type: %s\n', sub.MessageType);
fprintf('Waiting for messages... (Press Ctrl+C to stop)\n\n');

% Keep MATLAB running to receive messages
while true
    pause(0.1);  % Small pause to prevent high CPU usage
end

% Callback function that executes when a message is received
function subscriberCallback(msg)
    % Display the received message
    fprintf('[%s] Received: %s\n', datestr(now, 'HH:MM:SS.FFF'), msg.data);
end