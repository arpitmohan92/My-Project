locals {
  map_of_s3_buckets_dev = {
    va-edp-dev-databricks-root-backup = {
        bucket_name = "va-edp-dev-databricks-root-backup"
    },
    va-edp-dev-deep-clone = {
        bucket_name = "va-edp-dev-deep-clone"
    },
...

}


main.tf

module "s3-buckets-npr" {
    source      = "gitlab.com/virginaustralia/aws-s3-bucket/local"
    version     = "2.0.9"
    providers   = {aws = aws.edp-service-npr}
    for_each = {
         for key, value in local.map_of_s3_buckets : key => value
          if terraform.workspace == "npr"
    }
    bucket      = each.value.bucket_name
...
}
