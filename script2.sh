#!/bin/bash

# Get a list of RDS instances
rds_instances=$(aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier]' --output text)

# Iterate through each RDS instance
for instance in $rds_instances
do
    # Get the number of database connections for the last hour
    connections=$(aws cloudwatch get-metric-statistics --namespace AWS/RDS --metric-name DatabaseConnections --start-time "$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%SZ')" --end-time "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" --period 3600 --statistics Sum --dimensions Name=DBInstanceIdentifier,Value="$instance" --query 'Datapoints[0].Sum' --output text)

    # Check if there are any database connections
    if [ "$connections" -gt 0 ]; then
        echo "RDS instance $instance is connected to an application."
    else
        echo "RDS instance $instance has no active connections."
    fi
done
