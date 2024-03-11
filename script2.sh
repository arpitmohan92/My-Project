# Configure the S3 module
module "s3_bucket" {
  source  = "hashicorp/aws"
  version = ">= 3.7"

  bucket = var.bucket_name
  tags    = var.tags

  # Optional configurations
  acl_disabled          = var.disable_acl          # Disables object ownership for the bucket
  enable_versioning      = var.enable_versioning      # Enables versioning for the bucket
  server_side_encryption = var.server_side_encryption # Enables server-side encryption with AES256
  lifecycle_rule        = var.lifecycle_rule        # Defines a lifecycle rule for object expiration

  # Pass through configurations (if using the module)
  public_access_block {
    restrict_public_buckets = true
    block_public_policy    = true
    block_public_acls      = true
    ignore_public_acls     = true
  }
}
