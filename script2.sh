#!/bin/bash

# Set your AWS region
AWS_REGION="your-aws-region"

# Set the suppression reason
SUPPRESSION_REASON="Suppressing low alerts for maintenance window."

# Get all low severity finding IDs
LOW_FINDING_IDS=$(aws securityhub get-findings \
  --region $AWS_REGION \
  --filters "SeverityLabel=Low" \
  --query 'Findings[*].[Id]' \
  --output json)

# Suppress each low severity finding
for FINDING_ID in $(echo "${LOW_FINDING_IDS}" | jq -r '.[]'); do
  aws securityhub batch-update-findings \
    --region $AWS_REGION \
    --finding-identifiers Id=$FINDING_ID \
    --workflow Status=suppressed,StatusReason="$SUPPRESSION_REASON"
done
