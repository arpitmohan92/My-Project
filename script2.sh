#!/bin/bash

# Get a list of ECS clusters
ecs_clusters=$(aws ecs list-clusters --output json | jq -r '.clusterArns[]')

# Loop through each ECS cluster
for cluster in $ecs_clusters; do
    # Get the number of running tasks in the cluster
    running_tasks=$(aws ecs list-tasks --cluster $cluster --desired-status RUNNING --output json | jq -r '.taskArns | length')

    # If no running tasks, consider the cluster not in use
    if [ $running_tasks -eq 0 ]; then
        echo "ECS Cluster $cluster is not in use"
        # You can add additional actions here, such as recording the cluster name to a file or notifying someone.
    fi
done
