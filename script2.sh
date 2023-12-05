import boto3
import json
from datetime import datetime

ecs_client = boto3.client('ecs')

def lambda_handler(event, context):
    try:
        # Update ECS service
        ecs_client.update_service(
            cluster='dev',
            service='apps-checkin',
            forceNewDeployment=True
        )

        # Get current timestamp
        current_time = datetime.now()
        current_time_str = current_time.strftime('%Y-%m-%d %H:%M:%S')

        # Return JSON response
        response = {
            'statusCode': 200,
            'body': json.dumps({'message': 'Service updated successfully', 'timestamp': current_time_str})
        }

        return response
    except Exception as e:
        # Handle exceptions appropriately
        error_response = {
            'statusCode': 500,
            'body': json.dumps({'error_message': str(e)})
        }
        return error_response
