import boto3
from datetime import datetime, timedelta

def is_snapshot_in_use(ec2, snapshot_id):
    # Check if the snapshot is associated with an AMI
    images = ec2.describe_images(Filters=[{'Name': 'block-device-mapping.snapshot-id', 'Values': [snapshot_id]}])['Images']
    return bool(images)

def process_snapshots(ec2, snapshots, cutoff_date):
    deleted_snapshots = []
    for snapshot in snapshots:
        snapshot_date = snapshot['StartTime'].replace(tzinfo=None)
        if snapshot_date < cutoff_date and not is_snapshot_in_use(ec2, snapshot['SnapshotId']):
            # Delete the snapshot
            ec2.delete_snapshot(SnapshotId=snapshot['SnapshotId'])
            deleted_snapshots.append(snapshot['SnapshotId'])
    return deleted_snapshots

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
    
    # Describe snapshots in smaller batches using pagination
    paginator = ec2.get_paginator('describe_snapshots')
    response_iterator = paginator.paginate(OwnerIds=['self'])
    
    # Initialize a list to store deleted snapshots
    deleted_snapshots = []
    
    # Loop through each page of snapshots
    for page in response_iterator:
        # Process snapshots concurrently
        deleted_snapshots.extend(process_snapshots(ec2, page['Snapshots'], cutoff_date))
    
    # Print the IDs of the deleted snapshots
    print("Deleted Snapshots: {}".format(deleted_snapshots))

    return "Lambda execution completed."
n "Lambda execution completed."
