
locals {
  #IAM Roles
  iam_roles_map_dev = {
        cc-bayee-sns-push-notification-delivery-cw-log-role = {
            role_name = "cc-bayee-sns-push-notification-delivery-cw-log-role"
            role_description = "Role assumed for mobile push notification."
            custom_role_policy_attachments = [
                "cc-bayee-sns-push-notification-policy-dev",
            ]

             custom_trust_policy    = jsonencode(
{
	    "Version": "2012-10-17",
	    "Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "sts:AssumeRole"
		}
	]
}
)
        },                       
    }
    iam_roles_map_test = {}  
    iam_roles_map      = merge(local.iam_roles_map_dev,local.iam_roles_map_test)  


 iam_policies_map_dev = {
        cc-bayee-sns-push-notification-policy = {
            name = "cc-bayee-sns-push-notification-policy-dev"
            path = "/"
            description = "sns push notification policy"
            policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
  )
    }
    }
    iam_policies_map_test = {}
    iam_policies_map      = merge(local.iam_policies_map_dev,local.iam_policies_map_test)

  iam_roles_map_cloudwatch_dev = {
       new-relic-cloudwatch-streaming-to-firehose-role= {
            role_name = "cc-bayee-sns-subs-kinesis-role"
            role_description = "Role assumed for kinesis stream association"
            custom_role_policy_attachments = [
                "new-relic-cloudwatch-streaming-to-firehose",
            ]

 assume_role_policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "streams.metrics.cloudwatch.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "185345276083"
                }
            }
        },
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ap-southeast-2.amazonaws.com"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "185345276083"
                }
            }
        }
    ]
}
)
        },                       
    }
    iam_roles_map_cloudwatch_test = {}  
    iam_roles_map_cloudwatch      = merge(local.iam_roles_map_cloudwatch_dev,local.iam_roles_map_cloudwatch_test) 

iam_policies_map_cloudwatch-dev = {
        new-relic-cloudwatch-policy = {
            name = "new-relic-cloudwatch-streaming-to-firehose"
            path = "/"
            description = "cloudwatch streaming policy"
              policy = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:firehose:ap-southeast-2:185345276083:deliverystream/*",
            "Sid": "VisualEditor0"
        }
    ]
}
  )
    }
    }
    iam_policies_map_cloudwatch-test = {}
    iam_policies_map_cloudwatch       = merge(local.iam_policies_map_cloudwatch-dev,local.iam_policies_map_cloudwatch-test)


 log_group_map_dev=  {
    log_group_map={
    name              = "sns/ap-southeast-2/185345276083/app/GCM/va_app_android"
    retention_in_days = 120
}

 }
  log_group_map_test=  {}

    log_group_map_cloudwatch = merge(local.log_group_map_dev,local.log_group_map_test)

cloudwatch_logs_map_subscription_dev = {
    cloudwatch_logs_subscription_dev= {
  name = "va_app_android-filter"
}
}
cloudwatch_logs_map_subscription_test = {}
cloudwatch_logs_map_subscription = merge (local.cloudwatch_logs_map_subscription_dev,local.cloudwatch_logs_map_subscription_test)

}


