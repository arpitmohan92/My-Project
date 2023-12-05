import boto3
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

        # Serialize the response using boto3's json_util
        response_serializable = ecs_client.meta.events._json_handler(response, None)
        
        return response_serializable

    except Exception as e:
        return str(e)
