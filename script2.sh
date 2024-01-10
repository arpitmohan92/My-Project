import boto3

def lambda_handler(event, context):
    securityhub = boto3.client('securityhub')

    # Extracting findings from the event
    findings = event.get('detail', {}).get('findings', [])

    # List of severity levels to suppress (low and medium in this case)
    severity_to_suppress = ['LOW', 'MEDIUM']

    for finding in findings:
        severity = finding.get('Severity', {}).get('Label', '').upper()

        # Check if the severity level is in the list to suppress
        if severity in severity_to_suppress:
            # Suppress the finding
            response = securityhub.batch_update_findings(
                FindingIdentifiers=[{'Id': finding['Id'], 'ProductArn': finding['ProductArn']}],
                Note={'Text': 'Alert suppressed by Lambda function', 'UpdatedBy': 'Lambda'},
                Workflow={'Status': 'SUPPRESSED'}
            )
            print(f"Suppressed finding {finding['Id']} with severity {severity}")

    return {
        'statusCode': 200,
        'body': 'Alert suppression completed successfully.'
    }
