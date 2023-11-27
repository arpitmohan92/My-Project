#!/bin/bash

# Get all EC2 Security Group IDs
security_group_ids=($(aws ec2 describe-security-groups --query 'SecurityGroups[*].GroupId' --output text))

# Initialize an array to store unused security groups
unused_security_groups=()

# Loop through each Security Group ID
for security_group_id in "${security_group_ids[@]}"
do
    # Find the number of network interfaces associated with the Security Group
    num_network_interfaces=$(aws ec2 describe-network-interfaces \
        --filters "Name=group-id,Values=$security_group_id" \
        --query 'length(NetworkInterfaces)' \
        --output text)

    # Check if the Security Group is not in use
    if [ "$num_network_interfaces" -eq 0 ]; then
        # Get the name of the Security Group and add it to the array
        security_group_name=$(aws ec2 describe-security-groups --group-ids "$security_group_id" --query 'SecurityGroups[0].GroupName' --output text)
        unused_security_groups+=("$security_group_name")
    fi
done

# Print the names of unused security groups
echo "Unused Security Groups:"
for unused_group in "${unused_security_groups[@]}"
do
    echo "- $unused_group"
done
