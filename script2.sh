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
    
    # Describe all snapshots in the region
    response = ec2.describe_snapshots(OwnerIds=['self'])
    
    # Initialize a list to store deleted snapshots
    deleted_snapshots = []
    
    # Loop through each snapshot and delete if older than cutoff_date
    for snapshot in response['Snapshots']:
        snapshot_date = snapshot['StartTime'].replace(tzinfo=None)
        if snapshot_date < cutoff_date:
            # Delete the snapshot
            ec2.delete_snapshot(SnapshotId=snapshot['SnapshotId'])
            deleted_snapshots.append(snapshot['SnapshotId'])
    
    # Print the IDs of the deleted snapshots
    print("Deleted Snapshots: {}".format(deleted_snapshots))

    return "Lambda execution completed."
