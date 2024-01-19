#!/bin/bash

# Specify your S3 bucket name
s3_bucket="your-s3-bucket-name"

while IFS= read -r filename; do
  s3_path="s3://$s3_bucket/$filename"
  
  # Check if the file exists in S3
  if aws s3 ls "$s3_path" &>/dev/null; then
    # If the file exists, delete it
    aws s3 rm "$s3_path"
    echo "Deleted: $filename from $s3_bucket"
  else
    echo "File not found in $s3_bucket: $filename"
  fi
done < files.txt
