resource "aws_iam_role" "backup_role" {
  name               = var.iam_role_name == "" ? "aws-backup-plan-role" : var.iam_role_name
  assume_role_policy = jsonencode(
    {
      "Version" : "2008-10-17",
      "Statement" : [
        {
          "Effect" : "Allow"
          "Principal" : {
            "Service" : "cloudformation.amazonaws.com"
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

module "ts_sizzl_iam" {
  count         = terraform.workspace == "npr" ? 1 : 0
  source        = "./Modules/IAM/"
  iam_role_name = "aws-backup-reporter-cloudformation-role"
  tags = local.common_tags
  providers         = {aws = aws.ts-sizzl-backup-prd}
  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonAthenaFullAccess",
    "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess",
    "arn:aws:iam::aws:policy/AWSLambda_FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
  ]
}
