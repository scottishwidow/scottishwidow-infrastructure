variable "aws_region" {
  type        = string
  description = "AWS Region to deploy to"
  default     = "eu-central-1"
}

variable "tags" {
  description = "Tags applied to all resources in this root"
  type        = map(string)
  default = {
    env        = "honeynet"
    management = "terraform"
    Name       = "corpus"
  }
}

variable "corpus_bucket_prefix" {
  description = "Name prefix for the Corpus bucket. The account ID, region, and `-an` namespace suffix are appended (final name: <prefix>-<account-id>-<region>-an)."
  type        = string
  default     = "scottishwidow-honeynet-corpus"
}

variable "corpus_retention_days" {
  description = "Days after which a retained telemetry object expires. The default is 13 months."
  type        = number
  default     = 396

  validation {
    condition     = var.corpus_retention_days >= 1
    error_message = "Retention must be at least 1 day."
  }
}

variable "corpus_noncurrent_version_retention_days" {
  description = "Days after which a non-current object version expires. A version only exists when an object is overwritten, so it is kept for less time than the object itself."
  type        = number
  default     = 30

  validation {
    condition     = var.corpus_noncurrent_version_retention_days >= 1
    error_message = "Non-current version retention must be at least 1 day."
  }
}

variable "corpus_abort_incomplete_multipart_upload_days" {
  description = "Days after which an incomplete multipart upload is aborted and its parts are deleted."
  type        = number
  default     = 7

  validation {
    condition     = var.corpus_abort_incomplete_multipart_upload_days >= 1
    error_message = "Abort after must be at least 1 day."
  }
}
