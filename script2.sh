locals {
  cloud_id   = data.aws_ssm_parameter.cloud_id.value
  region     = data.aws_region.this.name
  account_id = data.aws_caller_identity.this.account_id
  # example how to get the network information about the account into which to deploy the service
  vpc = data.terraform_remote_state.network.outputs.accounts[local.account_id].vpcs["default"]

  map_of_s3_buckets_dev = {
    va-edp-dev-databricks-root-backup = {
      bucket_name = "va-aws-backup-reporter-ts-sizzl-backup-prd"
      region                       = "ap-southeast-2"  # Update with your desired AWS region
      disable_acl                  = false  # Set to true to disable ACL, false otherwise
      enable_versioning            = true   # Set to true to enable versioning, false otherwise
      lifecycle_rule_name          = "Delete_all_objects_after_120_days"

      lifecycle_rules = [
        {
          id     = "Delete_all_objects_after_120_days"
          status = "Enabled"
          expiration_days = 120
        }
  ]
}
}
}

module "s3_ts_sizzl-backup_reports" {
  source    = "terraform-aws-modules/s3-bucket/aws"
  version   = "4.1.1"
  providers = { aws = aws.ts-sizzl-backup-prd }

  tags = local.common_tags

  for_each = {
    for key, value in local.map_of_s3_buckets_dev : key => value
    if terraform.workspace == "npr"
  }

  bucket = each.value.bucket_name

  control_object_ownership             = try(each.value.control_object_ownership, false)
  object_ownership                     = try(each.value.object_ownership, BucketOwnerEnforced)
  versioning                           = try(each.value.versioning, {})
  server_side_encryption_configuration = try(each.value.server_side_encryption_configuration, {})

  block_public_acls   = try(each.value.block_public_acls, true)
  block_public_policy = try(each.value.block_public_policy, true)
  ignore_public_acls  = try(each.value.ignore_public_acls, true)

  lifecycle_rule = try(each.value.lifecycle_rules, [])
}
