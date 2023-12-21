import boto3
from datetime import datetime, timedelta

def lambda_handler(event, context):
    # Set the AWS region
    region = 'your_region'
    
    # Create EC2 client
    ec2 = boto3.client('ec2', region_name=region)
    
    # Get the current date
    current_date = datetime.utcnow()
    
    # Define the retention period (in days)
    retention_days = 30
    
    # Calculate the cutoff date for deletion
    cutoff_date = current_date - timedelta(days=retention_days)
    
    # Initialize a list to store deleted snapshots
    deleted_snapshots = []
    
    # Describe snapshots in smaller batches using pagination
    paginator = ec2.get_paginator('describe_snapshots')
    response_iterator = paginator.paginate(OwnerIds=['self'])
    
    # Loop through each page of snapshots
    for page in response_iterator:
        # Loop through each snapshot on the page
        for snapshot in page['Snapshots']:
            snapshot_date = snapshot['StartTime'].replace(tzinfo=None)
            if snapshot_date < cutoff_date:
                # Delete the snapshot
                ec2.delete_snapshot(SnapshotId=snapshot['SnapshotId'])
                deleted_snapshots.append(snapshot['SnapshotId'])
    
    # Print the IDs of the deleted snapshots
    print("Deleted Snapshots: {}".format(deleted_snapshots))

    return "Lambda execution completed."
