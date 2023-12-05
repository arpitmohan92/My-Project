import boto3

def lambda_handler(event, context):
    # Create ECS client
    ecs_client = boto3.client('ecs')

    # List ECS clusters
    response = ecs_client.list_clusters()

    if 'clusterArns' in response and response['clusterArns']:
        clusters = response['clusterArns']
        return {
            'statusCode': 200,
            'body': f'ECS Clusters: {clusters}'
        }
    else:
        return {
            'statusCode': 404,
            'body': 'No ECS clusters found.'
        }
