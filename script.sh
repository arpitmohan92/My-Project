#!/bin/bash

# Check if the file path is provided as an argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

# Read the file line by line and check if each computer name exists in AWS workspace
while IFS= read -r computer_name; do
    aws_workspaces=$(aws workspaces describe-workspaces --query "Workspaces[?WorkspaceId!='null'].ComputerName" --output text)
    if grep -q "$computer_name" <<< "$aws_workspaces"; then
        echo "$computer_name exists in AWS workspace"
    else
        echo "$computer_name does not exist in AWS workspace"
    fi
done < "$1"
