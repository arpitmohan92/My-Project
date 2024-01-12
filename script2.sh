import boto3

def get_low_alerts():
    # Set the AWS region
    region = 'ap-southeast-2'

    # Create SecurityHub client
    securityhub_client = boto3.client('securityhub', region_name=region)

    # Get findings with low severity
    response = securityhub_client.get_findings(
        Filters=[
            {
                'Name': 'SeverityLabel',
                'Values': ['LOW']
            }
        ]
    )

    # Extract and print findings
    findings = response.get('Findings', [])
    for finding in findings:
        print(f"Title: {finding['Title']}, Severity: {finding['Severity']['Label']}")

if __name__ == "__main__":
    get_low_alerts()
