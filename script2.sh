#!/bin/bash

# Output file for load balancer names with zero target instances
output_file="zero_target_lb_names.txt"

# Get a list of load balancer ARNs and names
load_balancers=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerArn,LoadBalancerName]' --output json --profile common-dev)

# Loop through each load balancer and check if none of the target groups have healthy targets
while IFS= read -r lb_info; do
    lb_arn=$(echo "$lb_info" | jq -r '.[0]')
    lb_name=$(echo "$lb_info" | jq -r '.[1]')

    # Get the target group ARNs for the load balancer
    target_group_arns=$(aws elbv2 describe-target-groups --load-balancer-arn "$lb_arn" --query 'TargetGroups[*].TargetGroupArn' --output json --profile common-dev)

    # Flag to check if any target group has healthy targets
    any_target_group_has_healthy_targets=false

    # Loop through each target group and check target health
    while IFS= read -r target_group_arn; do
        # Remove leading and trailing whitespaces and unexpected characters
        cleaned_target_group_arn=$(echo "$target_group_arn" | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        target_count=$(aws elbv2 describe-target-health --target-group-arn "$cleaned_target_group_arn" --query 'TargetHealthDescriptions[?TargetHealth.State==`healthy`].length(@)' --output json --profile common-dev)

        # Check if target_count is an integer
        if [[ "$target_count" =~ ^[0-9]+$ ]]; then
            if [ "$target_count" -ne 0 ]; then
                any_target_group_has_healthy_targets=true
                break  # Exit the loop if any target group has healthy targets
            fi
        else
            echo "Error: Unable to retrieve target count for Load Balancer '$lb_name' with ARN $lb_arn and Target Group ARN $cleaned_target_group_arn." >&2
        fi
    done <<< "$(echo "$target_group_arns" | jq -c -r '.[]')"

    # If none of the target groups have healthy targets, record the load balancer name
    if [ "$any_target_group_has_healthy_targets" = false ]; then
        echo "$lb_name" >> "$output_file"
    fi
done <<< "$(echo "$load_balancers" | jq -c '.[]')"

echo "Load balancer names with none of the target groups having healthy targets have been written to $output_file"
