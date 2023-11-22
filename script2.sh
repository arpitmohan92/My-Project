#!/bin/bash

# Output file for load balancer names with zero target instances
output_file="zero_target_lb_names.txt"

# Get a list of load balancer ARNs and names
load_balancers=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerArn,LoadBalancerName]' --output json --profile common-dev)

# Loop through each load balancer and check if all target groups have zero instances
while IFS= read -r lb_info; do
    lb_arn=$(echo "$lb_info" | jq -r '.[0]')
    lb_name=$(echo "$lb_info" | jq -r '.[1]')

    # Get the target group ARNs for the load balancer
    target_group_arns=$(aws elbv2 describe-target-groups --load-balancer-arn "$lb_arn" --query 'TargetGroups[*].TargetGroupArn' --output json --profile common-dev)

    # Flag to check if all target groups have zero instances
    all_target_groups_zero_instances=true

    # Loop through each target group and check instance count
    while IFS= read -r target_group_arn; do
        instance_count=$(aws elbv2 describe-target-health --target-group-arn "$target_group_arn" --query 'length(TargetHealthDescriptions)' --output json --profile common-dev)

        # Check if instance_count is an integer
        if [[ "$instance_count" =~ ^[0-9]+$ ]]; then
            if [ "$instance_count" -ne 0 ]; then
                all_target_groups_zero_instances=false
                break  # Exit the loop if any target group has non-zero instances
            fi
        else
            echo "Error: Unable to retrieve instance count for Load Balancer '$lb_name' with ARN $lb_arn and Target Group ARN $target_group_arn." >&2
        fi
    done <<< "$(echo "$target_group_arns" | jq -c -r '.[]')"

    # If all target groups have zero instances, record the load balancer name
    if [ "$all_target_groups_zero_instances" = true ]; then
        echo "$lb_name" >> "$output_file"
    fi
done <<< "$(echo "$load_balancers" | jq -c '.[]')"

echo "Load balancer names with all target groups having zero instances have been written to $output_file"
