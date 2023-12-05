import boto3
from datetime import datetime
from decimal import Decimal

ecs_client = boto3.client('ecs')

def custom_serializer(obj):
    if isinstance(obj, Decimal):
        return float(obj)
    elif isinstance(obj, datetime):
        return obj.isoformat()
    else:
        raise TypeError("Object of type {} is not JSON serializable".format(type(obj)))

def lambda_handler(event, context):
    try:
        response = ecs_client.update_service(
            cluster='dev',
            service='apps-checkin',
            forceNewDeployment=True
        )

        # Convert datetime object to string before returning
        response['timestamp'] = str(datetime.now())

        # Serialize the response using custom serializer
        response_serializable = custom_serializer(response)
        
        return response_serializable

    except Exception as e:
        return str(e)
