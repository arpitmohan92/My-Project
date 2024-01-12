import boto3

def lambda_handler(event, context):
    security_hub = boto3.client('securityhub')

    # Specify the finding types you want to suppress (e.g., LOW)
    finding_types_to_suppress = ['Low']

    # Specify the reason for suppression
    suppression_reason = 'Suppressing low alerts for maintenance window.'

    for finding_type in finding_types_to_suppress:
        response = security_hub.batch_update_findings(
            FindingIdentifiers=[
                {
                    'Id': finding['Id'],
                    'ProductArn': finding['ProductArn']
                }
                for finding in event['findings']
                if finding['Severity']['Label'] == finding_type
            ],
            Workflow=[
                {
                    'Status': 'SUPPRESSED',
                    'StatusReason': suppression_reason
                }
            ]
        )

    return {
        'statusCode': 200,
        'body': 'Low alerts suppressed successfully.'
    }
