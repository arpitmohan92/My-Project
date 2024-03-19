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
