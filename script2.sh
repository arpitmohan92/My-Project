import boto3

securityhub = boto3.client('securityhub')

suppress_alerts = lambda event, context: securityhub.batch_update_findings(
    FindingIdentifiers=[
        {
            'Id': finding['Id'],
            'ProductArn': finding['ProductArn']
        } for finding in securityhub.get_findings(
            Filters={
                'SeverityLabel': {
                    'Comparison': 'EQUALS',
                    'Value': 'LOW'
                },
                'ConfidenceLabel': {
                    'Comparison': 'EQUALS',
                    'Value': 'LOW'
                },
                'WorkflowState': {
                    'Comparison': 'NOT_EQUALS',
                    'Value': 'SUPPRESSED'
                }
            },
            MaxResults=10
        )['Findings']
    ],
    Workflow='SUPPRESS'
)
