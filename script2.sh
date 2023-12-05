import boto3

def lambda_handler(event, context):
    # Create EC2 client
    ec2_client = boto3.client('ec2')

    # List EC2 instances
    response = ec2_client.describe_instances()

    instances = []
    
    # Extract instance information from the response
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instances.append({
                'InstanceId': instance['InstanceId'],
                'InstanceType': instance['InstanceType'],
                'State': instance['State']['Name']
            })

    if instances:
        return {
            'statusCode': 200,
            'body': f'EC2 Instances: {instances}'
        }
    else:
        return {
            'statusCode': 404,
            'body': 'No EC2 instances found.'
        }

