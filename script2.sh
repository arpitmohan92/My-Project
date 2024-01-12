import boto3

def lambda_handler(event, context):
    securityhub = boto3.client('securityhub')

    for finding in event['detail']['findings']:
        if finding['Severity']['Label'] == 'LOW':  # Filter for low severity findings
            try:
                response = securityhub.update_findings(
                    Filters={'Id': [{'Value': finding['Id']}]},
                    Note={'Text': 'Suppressed by Lambda function'},
                    Workflow={'Status': 'SUPPRESSED'}
                )
                print(f"Suppressed finding: {finding['Id']}")
            except Exception as e:
                print(f"Error suppressing finding {finding['Id']}: {e}")

    return {
        'statusCode': 200,
        'body': 'Suppression function executed successfully.'
    }
