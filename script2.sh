#!/bin/bash

# Output file for load balancer names with instances in any target group
output_file="load_balancers_with_instances.txt"

# Get a list of load balancer ARNs and names
load_balancers=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerArn,LoadBalancerName]' --output json --profile common-dev)

# Loop through each load balancer and check if any target group has instances
while IFS= read -r lb_info; do
    lb_arn=$(echo "$lb_info" | jq -r '.[0]')
    lb_name=$(echo "$lb_info" | jq -r '.[1]')

    # Get the target group ARNs for the load balancer
    target_group_arns=$(aws elbv2 describe-target-groups --load-balancer-arn "$lb_arn" --query 'TargetGroups[*].TargetGroupArn' --output json --profile common-dev)

    # Check if any target group has instances
    if [ "$(echo "$target_group_arns" | jq 'length')" -gt 0 ]; then
        echo "$lb_name" >> "$output_file"
    fi
done <<< "$(echo "$load_balancers" | jq -c '.[]')"

echo "Load balancer names with instances in any target group have been written to $output_file"
