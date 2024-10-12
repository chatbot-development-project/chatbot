output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.chatbot_bucket.arn
}

output "secret_arn" {
  description = "The ARN of the Secrets Manager secret."
  value       = aws_secretsmanager_secret.secret.arn
}

output "secret_version_id" {
  description = "The ID of the Secrets Manager secret version."
  value       = aws_secretsmanager_secret_version.pinecone_api_key_version.id
}

output "knowledge_base_id" {
  description = "The ID of the Bedrock Knowledge Base."
  value       = awscc_bedrock_knowledge_base.knowledge.id
}

output "role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.bedrock_execution_role.arn
}

output "policy_arn" {
  description = "The ARN of the IAM policy."
  value       = aws_iam_policy.bedrock_policy.arn
}