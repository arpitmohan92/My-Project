import boto3

def lambda_handler(event, context):
    # Initialize Security Hub client
    securityhub = boto3.client('securityhub')

    # Specify the finding types and severity level to suppress
    finding_types_to_suppress = ['Low']
    
    # Iterate through findings in the event
    for finding in event['findings']:
        # Check if the finding type and severity match the ones to suppress
        if finding['Type'] in finding_types_to_suppress and finding['Severity']['Label'] == 'LOW':
            # Suppress the finding
            securityhub.batch_update_findings(
                FindingIdentifiers=[
                    {
                        'Id': finding['Id'],
                        'ProductArn': finding['ProductArn']
                    },
                ],
                Note={
                    'Text': 'Finding suppressed due to low severity.',
                    'UpdatedBy': 'Lambda Function'
                },
                Workflow={
                    'Status': 'SUPPRESSED'
                }
            )

    return {
        'statusCode': 200,
        'body': 'Low severity alerts suppressed successfully.'
    }
