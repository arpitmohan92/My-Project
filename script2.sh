import boto3

def lambda_handler(event, context):
    securityhub = boto3.client('securityhub')

    # Filter for low-severity findings
    findings = securityhub.get_findings(
        Filters={
            'SeverityLabel': [
                'LOW'
            ]
        }
    )['Findings']

    if findings:
        findingIds = [finding['Id'] for finding in findings]

        # Suppress the findings
        securityhub.batch_update_findings(
            FindingIdentifiers=findingIds,
            Workflow={'Status': 'SUPPRESSED'}
        )

    return {
        'statusCode': 200,
        'body': 'Low-severity findings suppressed.'
    }
