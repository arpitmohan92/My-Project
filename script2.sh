resource "aws_iam_role" "backup_role" {
  name               = var.iam_role_name == "" ? "aws-backup-plan-role" : var.iam_role_name
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Effect" : "Allow"
          "Principal" : {
            "Service" : var.trusted_aws_services
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  count      = length(var.role_policy_arns)
  role       = aws_iam_role.backup_role.name
  policy_arn = element(var.role_policy_arns, count.index)
}
