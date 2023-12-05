import boto3

ecs_client = boto3.client('ecs')

lambda_handler = lambda event, context: ecs_client.update_service(
    cluster='dev',
    service='apps-checkin',
    forceNewDeployment=True
)
