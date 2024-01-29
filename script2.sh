{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:UpdateService",
        "ecs:DescribeServices"
      ],
      "Resource": "arn:aws:ecs:your-region:your-account-id:service/your-cluster-name/your-service-name",
      "Condition": {
        "ArnEquals": {
          "ecs:cluster": "arn:aws:ecs:your-region:your-account-id:cluster/your-cluster-name"
        }
      }
    }
  ]
}
