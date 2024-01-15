#!/bin/bash

# Set your AWS region
AWS_REGION="your-aws-region"

# Set the suppression reason
SUPPRESSION_REASON="Suppressing low alerts for maintenance window."

# Get all low severity findings
LOW_FINDINGS=$(aws securityhub get-findings \
  --region $AWS_REGION \
  --filters "SeverityLabel=Low" \
  --output json)

# Suppress each low severity finding
echo "$LOW_FINDINGS" | jq -c '.Findings[]' | while read -r FINDING; do
  ID=$(echo "$FINDING" | jq -r '.Id')
  PRODUCT_ARN=$(echo "$FINDING" | jq -r '.ProductArn')

  aws securityhub batch-update-findings \
    --region $AWS_REGION \
    --finding-identifiers Id=$ID,ProductArn=$PRODUCT_ARN \
    --workflow Status=suppressed,StatusReason="$SUPPRESSION_REASON"
done
