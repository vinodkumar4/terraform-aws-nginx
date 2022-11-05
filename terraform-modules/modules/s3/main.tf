resource "aws_s3_bucket" "bucket" {

  bucket        = var.bucket_name
  bucket_prefix = var.bucket_prefix

  acl                 = length(var.grant) == 0 ? var.acl : null
  acceleration_status = var.acceleration_status
  force_destroy       = var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }
}