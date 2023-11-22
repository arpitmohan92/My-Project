#!/bin/bash

# Output file for load balancer names with zero target instances
output_file="zero_target_lb_names.txt"

# Get a list of load balancer ARNs and names
load_balancers=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].[LoadBalancerArn,LoadBalancerName]' --output json --profile common-dev)

# Loop through each load balancer and check if it has zero target instances
for lb_info in $(echo "$load_balancers" | jq -c '.[]'); do
    lb_arn=$(echo "$lb_info" | jq -r '.[0]')
    lb_name=$(echo "$lb_info" | jq -r '.[1]')

    # Get the target group ARNs for the load balancer
    target_group_arns=$(aws elbv2 describe-target-groups --load-balancer-arn $lb_arn --query 'TargetGroups[*].TargetGroupArn' --output json --profile common-dev)

    # Loop through each target group and check target health
    for target_group_arn in $(echo "$target_group_arns" | jq -r '.[]'); do
        # Validate that the string appears to be a valid ARN
        if [[ "$target_group_arn" =~ ^arn:aws:elasticloadbalancing:[^:]+:targetgroup/[^/]+$ ]]; then
            target_count=$(aws elbv2 describe-target-health --target-group-arn $target_group_arn --query 'TargetHealthDescriptions[?TargetHealth.State==`healthy`].length(@)' --output json --profile common-dev)

            # Check if target_count is an integer
            if [[ "$target_count" =~ ^[0-9]+$ ]]; then
                if [ "$target_count" -eq 0 ]; then
                    echo "$lb_name" >> "$output_file"
                fi
            else
                echo "Error: Unable to retrieve target count for Load Balancer '$lb_name' with ARN $lb_arn and Target Group ARN $target_group_arn." >&2
            fi
        else
            echo "Error: Invalid target group ARN format: $target_group_arn for Load Balancer '$lb_name' with ARN $lb_arn." >&2
        fi
    done
done

echo "Load balancer names with zero target instances have been written to $output_file"
