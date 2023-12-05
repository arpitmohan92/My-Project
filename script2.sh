import boto3
from datetime import datetime

ecs_client = boto3.client('ecs')

def lambda_handler(event, context):
    response = ecs_client.update_service(
        cluster='dev',
        service='apps-checkin',
        forceNewDeployment=True
    )

    # Convert datetime object to string before returning
    response['timestamp'] = datetime.now().isoformat()

    return response
