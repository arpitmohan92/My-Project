#!/bin/bash

# Record start time
start_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script started at: $start_time" > output.txt

# Specify your S3 bucket name
bucket_name="your-s3-bucket-name"

# Read file paths from file.txt and delete each file
while IFS= read -r file_path; do
    aws s3 rm "s3://$bucket_name/$file_path" >> output.txt 2>&1
done < file.txt

# Record end time
end_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "Script completed at: $end_time" >> output.txt

# Display execution time
echo "Execution time: $(($(date -d "$end_time" +%s) - $(date -d "$start_time" +%s))) seconds" >> output.txt
