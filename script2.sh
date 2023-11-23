#!/bin/bash

# Output file for ASG names with running instances
output_file="running_instances_asg.txt"

# Get a list of Auto Scaling Groups and their instances
asg_instances=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].[AutoScalingGroupName,Instances[*].InstanceId]' --output json)

# Loop through each ASG and check if it has running instances
echo "$asg_instances" | jq -c -r '.[] | select(.[1] != null) | .[0]' > "$output_file"

echo "Auto Scaling Group names with running instances have been written to $output_file"
