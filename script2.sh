aws securityhub get-findings --region ap-southeast-2 --profile training-account --output json --filters "SeverityLabel=LOW"

Parameter validation failed:
Invalid type for parameter Filters.SeverityLabel[0], value: LOW, type: <class 'str'>, valid types: <class 'dict'>
