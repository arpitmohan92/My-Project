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
        "ecs:UpdateService",
	      "ecs:DescribeServices"
      ],
      "Resource": "arn:aws:ecs:ap-southeast-2:254109311541:service/prod-Restricted-Cluster/lms-offer-preferences-service",
      "Condition": {
        "ArnEquals": {
          "ecs:cluster": "arn:aws:ecs:ap-southeast-2:254109311541:cluster/prod-Restricted-Cluster"
       }	  
      }
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
resource "aws_lambda_function" "ecs_service_restart" {
  function_name = "ECS-service-restart"
  filename      = "ECS_service_restart.zip"
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
  schedule_expression = "cron(0 7,16 * * ? *)"  

  event_pattern = <<EOF
{
  "source": ["aws.events"],
  "detail": {
    "eventName": ["EcsServiceRestartEvent"]
  }
}
EOF
}

# EventBridge Rule Target to invoke Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule_rule.name
  target_id = "invoke_lambda_function"

  arn = aws_lambda_function.ecs_service_restart.arn
}
