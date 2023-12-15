#!/bin/bash

# Get a list of all Elastic IPs
elastic_ips=$(aws ec2 describe-addresses --query 'Addresses[*].[AllocationId, AssociationId]' --output text)

# Create an array to store unassociated Elastic IPs
unassociated_ips=()

# Loop through each Elastic IP and check if it's associated
while read -r allocation_id association_id; do
    if [ -z "$association_id" ]; then
        unassociated_ips+=("$allocation_id")
    fi
done <<< "$elastic_ips"

# Write unassociated Elastic IPs to a file
if [ ${#unassociated_ips[@]} -gt 0 ]; then
    echo "Unassociated Elastic IPs:" > unassociated_ips.txt
    for allocation_id in "${unassociated_ips[@]}"; do
        echo "$allocation_id" >> unassociated_ips.txt
    done
    echo "List of unassociated Elastic IPs written to unassociated_ips.txt"
else
    echo "No unassociated Elastic IPs found."
fi
