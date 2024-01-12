import boto3
import logging

def lambda_handler(event, context):
    logging.getLogger().setLevel(logging.INFO)  # Enable logging

    try:
        securityhub = boto3.client('securityhub')

        findings = event.get('detail', {}).get('findings')
        if findings:
            findingIds = [finding['Id'] for finding in findings]

            securityhub.batch_update_findings(
                FindingIdentifiers=findingIds,
                Workflow={'Status': 'SUPPRESSED'}
            )

            return {
                'statusCode': 200,
                'body': 'Low-severity findings suppressed.'
            }
        else:
            logging.warning("Event does not contain 'detail' or 'findings' keys")
            return {
                'statusCode': 400,
                'body': 'Invalid event structure'
            }
    except Exception as e:
        logging.error(f"Error suppressing findings: {e}")
        return {
            'statusCode': 500,
            'body': 'Internal server error'
        }
