module "corpus" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "5.17.0"

  bucket           = format("%s-%s-%s-an", var.corpus_bucket_prefix, data.aws_caller_identity.current.account_id, data.aws_region.current.region)
  bucket_namespace = "account-regional"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_deny_insecure_transport_policy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  }

  lifecycle_rule = [
    {
      id      = "expire-retained-telemetry"
      enabled = true
      filter  = {}

      expiration = {
        days = var.corpus_retention_days
      }

      noncurrent_version_expiration = {
        days = var.corpus_noncurrent_version_retention_days
      }

      abort_incomplete_multipart_upload_days = var.corpus_abort_incomplete_multipart_upload_days
    }
  ]

  tags = var.tags
}
