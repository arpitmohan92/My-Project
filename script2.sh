import boto3
import json
from datetime import datetime

ecs_client = boto3.client('ecs')

def lambda_handler(event, context):
    try:
        response = ecs_client.update_service(
            cluster='dev',
            service='apps-checkin',
            forceNewDeployment=True
        )

        # Convert datetime object to string before returning
        response['timestamp'] = str(datetime.now())
        
        # Ensure all elements are serializable
        response_serializable = json.loads(json.dumps(response, default=str))
        
        return response_serializable

    except Exception as e:
        return str(e)
