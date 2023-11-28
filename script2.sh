#!/bin/bash

# Get a list of all Elastic IPs
all_ips=$(aws ec2 describe-addresses --query 'Addresses[*].PublicIp' --output text)

# Iterate through each Elastic IP
for ip in $all_ips; do
    # Check if the Elastic IP is associated with any resource
    association=$(aws ec2 describe-addresses --public-ips $ip --query 'Addresses[*].AssociationId' --output text)
    
    if [ -z "$association" ]; then
        echo "Unattached Elastic IP: $ip"
    fi
done
