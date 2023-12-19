#!/bin/bash

# Set your AWS CLI profile and region
AWS_PROFILE="your_aws_profile"
AWS_REGION="your_aws_region"

# Get VPC ID
VPC_ID="your_vpc_id"

# Check if VPC exists
aws ec2 describe-vpcs --vpc-ids "$VPC_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "VPC with ID $VPC_ID does not exist or there was an issue retrieving information."
    exit 1
fi

# Check Subnet usage
SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json | jq -r '.Subnets | length')
if [ "$SUBNETS" -eq 0 ]; then
    echo "No subnets found for VPC $VPC_ID."
else
    echo "Subnets found: $SUBNETS"
fi

# Check Security Group usage
SECURITY_GROUPS=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json | jq -r '.SecurityGroups | length')
if [ "$SECURITY_GROUPS" -eq 0 ]; then
    echo "No security groups found for VPC $VPC_ID."
else
    echo "Security groups found: $SECURITY_GROUPS"
fi

# Check Route Table usage
ROUTE_TABLES=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json | jq -r '.RouteTables | length')
if [ "$ROUTE_TABLES" -eq 0 ]; then
    echo "No route tables found for VPC $VPC_ID."
else
    echo "Route tables found: $ROUTE_TABLES"
fi

# Check Network ACL usage
NETWORK_ACLS=$(aws ec2 describe-network-acls --filters "Name=vpc-id,Values=$VPC_ID" --profile "$AWS_PROFILE" --region "$AWS_REGION" --output json | jq -r '.NetworkAcls | length')
if [ "$NETWORK_ACLS" -eq 0 ]; then
    echo "No network ACLs found for VPC $VPC_ID."
else
    echo "Network ACLs found: $NETWORK_ACLS"
fi

echo "Script execution completed."
