#!/bin/bash

# Replace 'your_region' with the actual AWS region where your Security Hub is deployed
AWS_REGION="your_region"

# Get the product ARN for AWS Security Hub
AWS_PRODUCT_ARN=$(aws securityhub describe-products --region $AWS_REGION --query 'Products[0].ProductArn' --output text)

if [ -z "$AWS_PRODUCT_ARN" ]; then
    echo "Error: Unable to retrieve AWS Security Hub product ARN."
    exit 1
fi

# Get the list of low severity findings
LOW_FINDINGS=$(aws securityhub get-findings --region $AWS_REGION --severity-labels LOW --product-arn $AWS_PRODUCT_ARN --query 'Findings[].Id' --output text)

# Suppress low severity findings
for FINDING_ID in $LOW_FINDINGS; do
    aws securityhub batch-update-findings --region $AWS_REGION --finding-identifiers Id=$FINDING_ID,ProductArn=$AWS_PRODUCT_ARN --note "Text=Finding suppressed by shell script",UpdatedBy="ShellScript" --workflow Status="SUPPRESSED"
done

echo "Low severity findings suppressed successfully."
