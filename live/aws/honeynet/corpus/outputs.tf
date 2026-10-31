output "corpus_bucket_name" {
  description = "Name of the Corpus bucket"
  value       = module.corpus.s3_bucket_id
}

output "corpus_bucket_arn" {
  description = "ARN of the Corpus bucket"
  value       = module.corpus.s3_bucket_arn
}

output "corpus_bucket_regional_domain_name" {
  description = "Regional domain name of the Corpus bucket"
  value       = module.corpus.s3_bucket_bucket_regional_domain_name
}
