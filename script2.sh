#!/bin/bash

# Get a list of all Lambda functions
lambda_functions=$(aws lambda list-functions --query 'Functions[*].FunctionName' --output text)

# Loop through each function and check if it has any event source mappings
for function_name in $lambda_functions; do
    event_sources=$(aws lambda list-event-source-mappings --function-name $function_name --query 'EventSourceMappings' --output text)
    
    # If the function has no event sources, consider it as potentially unused
    if [ -z "$event_sources" ]; then
        echo "Unused Lambda function: $function_name"
    fi
done
