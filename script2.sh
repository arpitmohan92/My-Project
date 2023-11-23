#!/bin/bash

# Specify the file to store the output
output_file="zero_instance_groups.txt"

# Get the list of Auto Scaling Groups
auto_scaling_groups=$(aws autoscaling describe-auto-scaling-groups --query 'AutoScalingGroups[*].AutoScalingGroupName' --output text)

# Iterate through each Auto Scaling Group
for group in $auto_scaling_groups; do
    # Get the desired capacity (current number of instances) for the Auto Scaling Group
    desired_capacity=$(aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $group --query 'AutoScalingGroups[*].DesiredCapacity' --output text)

    # Check if the desired capacity is zero
    if [ $desired_capacity -eq 0 ]; then
        echo "Auto Scaling Group with zero instances: $group" >> "$output_file"
    fi
done

echo "Output written to: $output_file"
