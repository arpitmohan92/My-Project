# Creates a standard S3 bucket
resource "aws_s3_bucket" "bucket" {
    bucket      = var.bucket_name
    tags        = var.tags
}

resource "aws_s3_bucket_ownership_controls" "acl_disabled" {
    count  = var.disable_acl ? 1 : 0
    bucket = aws_s3_bucket.bucket.id
    rule {
        object_ownership = "BucketOwnerEnforced"
    }
}

resource "aws_s3_bucket_ownership_controls" "acl_enabled" {
    count  = var.disable_acl ? 0 : 1
    bucket = aws_s3_bucket.bucket.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_versioning" "bucket" {
    count  = var.enable_versioning ? 1 : 0
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
    bucket = aws_s3_bucket.bucket.id
    rule {
        apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
        }
    }
}

resource "aws_s3_bucket_public_access_block" "bucket" {
    bucket                  = aws_s3_bucket.bucket.id
    restrict_public_buckets = true
    block_public_policy     = true
    block_public_acls       = true
    ignore_public_acls      = true
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  bucket      = aws_s3_bucket.bucket.id
  rule {
    id     = var.lifecycle_rule_name
    status = "Enabled"
    expiration {
      days = var.lifecycle_object_expire_days
    }
  }
}
