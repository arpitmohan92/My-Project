#!/bin/bash

# Get a list of all Elastic IPs
elastic_ips=$(aws ec2 describe-addresses --query 'Addresses[].[AllocationId,InstanceId]' --output json)

# Initialize arrays to store unassociated EIPs in JSON and plain text format
unassociated_eips_json=()
unassociated_eips_plain=()

# Loop through each Elastic IP
while IFS= read -r eip_info; do
    allocation_id=$(echo "$eip_info" | jq -r '.[0]')
    instance_id=$(echo "$eip_info" | jq -r '.[1]')

    # Check if Elastic IP is unassociated
    if [ "$instance_id" == "null" ]; then
        unassociated_eips_json+=("{\"AllocationId\": \"$allocation_id\"}")
        unassociated_eips_plain+=("$allocation_id")
    fi
done <<< "$elastic_ips"

# Save results to files
echo "${unassociated_eips_json[@]}" > unassociated_eips.json
echo "${unassociated_eips_plain[@]}" > unassociated_eips.txt

echo "Unassociated Elastic IPs:"
cat unassociated_eips_plain.txt
