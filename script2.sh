import boto3

def lambda_handler(event, context):
    # Specify the region where your Security Hub is located
    security_hub = boto3.client('securityhub', region_name='your_region')

    findings = event.get('detail', {}).get('findings', [])

    for finding in findings:
        severity = finding.get('Severity', {})
        if severity.get('Label') == 'LOW':
            # Suppress low severity findings
            security_hub.batch_update_findings(
                FindingIdentifiers=[
                    {
                        'Id': finding['Id'],
                        'ProductArn': finding['ProductArn']
                    },
                ],
                Note={
                    'Text': 'Finding suppressed by Lambda function',
                    'UpdatedBy': 'LambdaFunction'
                },
                Workflow={
                    'Status': 'SUPPRESSED'
                }
            )

    return {
        'statusCode': 200,
        'body': 'Low severity findings suppressed successfully.'
    }
