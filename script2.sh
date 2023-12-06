{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:RegisterTaskDefinition",
        "ecs:UpdateService",
        "ecs:UpdateTaskSet",
        "ecs:UpdateCluster"
      ],
      "Resource": "arn:aws:ecs:region:account-id:cluster/your-ecs-cluster-name"
    }
  ]
}
