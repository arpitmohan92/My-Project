import boto3

def lambda_handler(event, context):
    securityhub = boto3.client('securityhub')

    findings_to_suppress = securityhub.get_findings(
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

    if findings_to_suppress:
        suppressed_findings = []

        for finding in findings_to_suppress:
            suppressed_findings.append({
                'Id': finding['Id'],
                'ProductArn': finding['ProductArn']
            })

        securityhub.batch_update_findings(
            FindingIdentifiers=suppressed_findings,
            Workflow='SUPPRESS'
        )

        return {
            'statusCode': 200,
            'body': 'Successfully suppressed findings.'
        }
    else:
        return {
            'statusCode': 200,
            'body': 'No findings to suppress.'
        }
