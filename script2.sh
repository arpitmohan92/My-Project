# IAM Role
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

# IAM Policy
resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda execution role"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeSnapshots",
        "ec2:DescribeSnapshotAttribute",
        "ec2:DescribeSnapshotTierStatus",
        "ec2:DescribeImages",
        "ec2:DeleteSnapshot"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach Policy
resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

#Zip file
#data "archive_file" "main" {
#  type        = "zip"
#  source_file = "./file/lambda_function.py"
#  output_path = "EBS_Snapshot_Deletion.zip"
#}

# Lambda Function
resource "aws_lambda_function" "snapshot_cleanup" {
  function_name = "Ebs-snapshot-cleanup"
  filename      = "EBS_Snapshot_Deletion.zip"
#  source_code_hash = data.archive_file.main.output_base64sha256
  runtime       = "python3.12"
  handler       = "lambda_function.lambda_handler"
  timeout       = 600
  role = aws_iam_role.lambda_execution_role.arn
}

# EventBridge Rule
resource "aws_cloudwatch_event_rule" "daily_schedule_rule" {
  name                = "daily_schedule_rule"
  description         = "Rule to trigger Lambda function daily"
  schedule_expression = "cron(0 0 * * ? *)"  

  event_pattern = <<EOF
{
  "source": ["aws.events"],
  "detail": {
    "eventName": ["SnapshotCleanupEvent"]
  }
}
EOF
}

# EventBridge Rule Target to invoke Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule_rule.name
  target_id = "invoke_lambda_function"

  arn = aws_lambda_function.snapshot_cleanup.arn
}
