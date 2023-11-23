#!/bin/bash

# Specify your AWS region
AWS_REGION="your-region"

# Specify your AWS CLI profile
AWS_PROFILE="common-dev"

# Get a list of all security group IDs
all_security_groups=$(aws ec2 describe-security-groups --region $AWS_REGION --profile $AWS_PROFILE --query 'SecurityGroups[*].GroupId' --output text)

# Initialize an array to store unattached security groups
unattached_security_groups=()

# Loop through each security group
for sg_id in $all_security_groups; do
    # Check if the security group is attached to any resource
    attached_resources=$(aws ec2 describe-instances --region $AWS_REGION --profile $AWS_PROFILE --filters Name=instance.group-id,Values=$sg_id --query 'Reservations[*].Instances[*].InstanceId' --output text)
    
    # If not attached, add to the unattached_security_groups array
    if [ -z "$attached_resources" ]; then
        unattached_security_groups+=("$sg_id")
    fi
done

# Save the unattached security groups to a file
echo "${unattached_security_groups[@]}" > unattached_security_groups.txt

echo "Unattached security groups have been recorded in unattached_security_groups.txt"
