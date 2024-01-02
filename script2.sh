provider "aws" {
  region = "your_region"
}

# IAM Role for Lambda Execution
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

# IAM Policy for Lambda Execution Role
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
        "ec2:DeleteSnapshot"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach Policy to Lambda Execution Role
resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

# Lambda Function
resource "aws_lambda_function" "snapshot_cleanup" {
  function_name = "snapshot-cleanup"
  runtime       = "python3.8"
  handler       = "handler.lambda_handler"
  timeout       = 300

  # Include your Lambda function code
  # e.g., deployment_package = filebase64("path/to/your/package.zip")
  # or use inline_code = "your inline code here"

  role = aws_iam_role.lambda_execution_role.arn

  environment {
    variables = {
      # Add any environment variables your Lambda function may need
    }
  }
}

# Lambda Permission for SNS Event Source
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.snapshot_cleanup.function_name
  principal     = "sns.amazonaws.com"
}

# EventBridge Rule for Daily Schedule
resource "aws_cloudwatch_event_rule" "daily_schedule_rule" {
  name                = "daily_schedule_rule"
  description         = "Rule to trigger Lambda function daily"
  schedule_expression = "cron(0 0 * * ? *)"  # Daily at midnight UTC

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
