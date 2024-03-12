# locals.tf

locals {
  map_of_s3_buckets_dev = {
    va-edp-dev-databricks-root-backup = {
      bucket_name = "va-edp-dev-databricks-root-backup"
    },
    va-edp-dev-deep-clone = {
      bucket_name = "va-edp-dev-deep-clone"
    },
    # Add more S3 buckets as needed
  }

  region                       = "us-east-1"  # Update with your desired AWS region
  disable_acl                  = false  # Set to true to disable ACL, false otherwise
  enable_versioning            = true   # Set to true to enable versioning, false otherwise
  lifecycle_rule_name          = "example-lifecycle-rule"
  lifecycle_object_expire_days = 30     # Adjust the expiration days as needed

  tags = {
    Environment = "production"
    Project     = "example-project"
  }

  lifecycle_rules = [
    {
      id     = local.lifecycle_rule_name
      status = "Enabled"
      expiration_days = local.lifecycle_object_expire_days
    }
    # Add more lifecycle rules as needed
  ]
}
