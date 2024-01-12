import boto3

def lambda_handler(event, context):
    if 'findings' in event:
        security_hub = boto3.client('securityhub')

        finding_types_to_suppress = ['Low']
        suppression_reason = 'Suppressing low alerts for maintenance window.'

        for finding in event['findings']:
            severity_label = finding.get('Severity', {}).get('Label', '')

            if severity_label in finding_types_to_suppress:
                response = security_hub.batch_update_findings(
                    FindingIdentifiers=[
                        {
                            'Id': finding['Id'],
                            'ProductArn': finding['ProductArn']
                        }
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
    else:
        return {
            'statusCode': 400,
            'body': 'No findings key in the event payload.'
        }
