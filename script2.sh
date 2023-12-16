#!/bin/bash

# Set AWS CLI profile and region
AWS_PROFILE="your_aws_profile"
AWS_REGION="your_aws_region"

# Set the output file path
OUTPUT_FILE="inactive_lambda_functions.txt"

# Get current date
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Calculate the date 3 months ago
THREE_MONTHS_AGO=$(date -u -d '3 months ago' +"%Y-%m-%dT%H:%M:%SZ")

# List all Lambda functions
FUNCTIONS=$(aws lambda list-functions --profile $AWS_PROFILE --region $AWS_REGION --output json)

# Check each function's last invocation time
for row in $(echo "${FUNCTIONS}" | jq -c '.Functions[]'); do
    FUNCTION_NAME=$(echo "${row}" | jq -r '.FunctionName')
    LAST_INVOCATION=$(aws lambda list-invocations --function-name $FUNCTION_NAME --profile $AWS_PROFILE --region $AWS_REGION --max-items 1 --output json | jq -r '.Invocations[0].InvocationTime')

    # If last invocation is earlier than three months ago, record the function
    if [[ "$LAST_INVOCATION" < "$THREE_MONTHS_AGO" || -z "$LAST_INVOCATION" ]]; then
        echo "$FUNCTION_NAME" >> "$OUTPUT_FILE"
    fi
done

echo "Inactive Lambda functions recorded in $OUTPUT_FILE"
