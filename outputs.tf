
output "s3_bucket_arn" {
  value       = data.aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}
output "dynamodb_table_name" {
  value       = data.aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}

 