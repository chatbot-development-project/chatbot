# Retrieve account ID
data "aws_caller_identity" "current" {}

# create a s3 bucket to upload file for the knowledgebase
resource "aws_s3_bucket" "chatbot_bucket" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "chatbot-development-project-bedrock-knowledgebase"
    Environment = "Development"
  }
}

# Random string resource
resource "random_string" "rand" {
  length  = 6
  special = false
}

# create aws secret to store the pine cone api key that will be passed to the knowledege base as a ref to the pine cone db
resource "aws_secretsmanager_secret" "secret" {
  # name        = var.secret_name
  name = "${var.secret_name}-${random_string.rand.result}"
  description = "Secret for chatbot development project bedrock knowledgebase"
}

resource "aws_secretsmanager_secret_version" "pinecone_api_key_version" {
  secret_id     = aws_secretsmanager_secret.secret.id
  #secret_string = "2b5ce643-10c0-4217-8a50-39d7ad5db07e"
  secret_string = jsonencode({
    apiKey = "2b5ce643-10c0-4217-8a50-39d7ad5db07e"
  })
}

# create the aws knowledgebase resource
# awscc_bedrock_knowledge_base


resource "awscc_bedrock_knowledge_base" "knowledge" {
  name        = var.knowledge_base_name
  description = "Knowledge base for the chatbot-development-project-bedrock-knowledgebase"
  role_arn    = aws_iam_role.bedrock_execution_role.arn #  (String) The ARN of the IAM role with permissions to invoke API operations on the knowledge base. The ARN must begin with AmazonBedrockExecutionRoleForKnowledgeBase_

  storage_configuration = {
    type = "PINECONE"
    pinecone_configuration = {
        connection_string = var.index_management_page_url  # The endpoint URL for your index management page.
        credentials_secret_arn = aws_secretsmanager_secret.secret.arn  # The ARN of the secret that you created in AWS Secrets Manager that is linked to your Pinecone API key.
        field_mapping = {
          metadata_field = var.metadata_field
          text_field     = var.text_field
      }
    }
  }

  knowledge_base_configuration = {
    type = "VECTOR"
    vector_knowledge_base_configuration = {
      embedding_model_arn = "arn:aws:bedrock:us-east-1::foundation-model/cohere.embed-english-v3"
    }
  }

  depends_on = [aws_iam_role.bedrock_execution_role, aws_iam_policy.bedrock_policy]
}


# Create an S3 datasource for the Bedrock knowledgebase
resource "awscc_bedrock_data_source" "data_source" {
  name              = "knowledge-base-data-source"
  knowledge_base_id = awscc_bedrock_knowledge_base.knowledge.id
  description       = "This resource defines a data source for an AWS Bedrock knowledge base, integrating with an S3 bucket."

  data_source_configuration = {
    s3_configuration = {
      bucket_arn         = aws_s3_bucket.chatbot_bucket.arn
    }
    type = "S3"
  }
}

# Define the IAM Role with the specified trust policy
resource "aws_iam_role" "bedrock_execution_role" {
  name = "AmazonBedrockExecutionRoleForKnowledgeBase"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AmazonBedrockKnowledgeBaseTrustPolicy"
        Effect = "Allow"
        Principal = {
          Service = "bedrock.amazonaws.com"
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:SourceAccount": data.aws_caller_identity.current.account_id
          }
          ArnLike = {
            "aws:SourceArn": "arn:aws:bedrock:us-east-1:*:knowledge-base/*"
          }
        }
      }
    ]
  })
}

# Define the IAM policy
resource "aws_iam_policy" "bedrock_policy" {
  name        = "bedrock_policy"
  description = "Policy for Bedrock model invocation, S3 access, and Secrets Manager access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "BedrockInvokeModelStatement"
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeAPI",
          "bedrock:*"
        ]
        Resource = [
          "arn:aws:bedrock:us-east-1::foundation-model/cohere.embed-english-v3",
          "*"
        ]
      },
      {
        Sid = "S3ListBucketStatement"
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.chatbot_bucket.arn
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = [
              data.aws_caller_identity.current.account_id
            ]
          }
        }
      },
      {
        Sid = "S3GetObjectStatement"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.chatbot_bucket.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceAccount" = [
              data.aws_caller_identity.current.account_id
            ]
          }
        }
      },
      {
        Sid = "SecretsManagerFullaccess"
        Effect = "Allow"
        Action = [
          "secretsmanager:*",
          "secretsmanager:GetSecretValue"
        ]
        Resource = [ 
          aws_secretsmanager_secret.secret.arn
        ]
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "bedrock_policy_attachment" {
  role       = aws_iam_role.bedrock_execution_role.name
  policy_arn = aws_iam_policy.bedrock_policy.arn
}



# check the resource block for the secret manager in the secrets manager policy
# ref the secret manager arn into the resource block of the secret manager 
# dont forget to pass the knowledge base id in process stream


# "arn:aws:secretsmanager:us-east-1:${data.aws_caller_identity.current.account_id}:secret/${var.secret_name}*"

# bedrock knowledeg base resource would depend on the policy and excecution role
