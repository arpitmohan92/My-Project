#!/bin/bash

# Specify your AWS region
AWS_REGION="your-region"

# Specify your AWS CLI profile
AWS_PROFILE="common-dev"

# Get a list of all RDS instances
all_rds_instances=$(aws rds describe-db-instances --region $AWS_REGION --profile $AWS_PROFILE --query 'DBInstances[*].[DBInstanceIdentifier, DBClusterIdentifier, CurrentConnections]' --output table)

# Initialize an array to store RDS instances with zero connections
zero_connections_rds=()

# Loop through each RDS instance
while read -r rds_instance; do
    # Extract the number of current connections
    current_connections=$(echo $rds_instance | awk '{print $NF}')

    # Check if the number of connections is zero
    if [ "$current_connections" -eq 0 ]; then
        zero_connections_rds+=("$rds_instance")
    fi
done <<< "$all_rds_instances"

# Save the RDS instances with zero connections to a file
echo "${zero_connections_rds[@]}" > zero_connections_rds.txt

echo "RDS instances with zero connections have been recorded in zero_connections_rds.txt"
