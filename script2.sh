import boto3

def lambda_handler(event, context):
    security_hub = boto3.client('securityhub')

    # Define the alert title to suppress
    alert_title_to_suppress = "Amazon S3 Block Public Access was disabled for S3 bucket crewmgmt-Afro-s3-Qa"

    # Iterate through findings in the event
    for finding in event['detail']['findings']:
        if 'Title' in finding['title'] and finding['title'] == alert_title_to_suppress:
            # Suppress low alerts
            security_hub.batch_update_findings(
                FindingIdentifiers=[
                    {
                        'Id': finding['id'],
                        'ProductArn': finding['productArn']
                    },
                ],
                Workflow={
                    'Status': 'SUPPRESSED'
                }
            )

    return {
        'statusCode': 200,
        'body': 'Alert suppression complete.'
    }
