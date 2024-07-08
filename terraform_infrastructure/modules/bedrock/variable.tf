variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "chatbot-development-project-bedrock-knowledgebase1234"
}

variable "secret_name" {
  description = "The name of the Secrets Manager secret"
  type        = string
  default     = "pinecone_secret_api_key"
}

variable "index_management_page_url" {
  description = "the connection string is the endpoint URL for your index management page."
  type        = string
  default     = "https://chatbot-development-bedrock-knowledgebase-7klvp3n.svc.aped-4627-b74a.pinecone.io/"
}

variable "knowledge_base_name" {
  description = "The name of the knowledge base"
  type        = string
  default     = "knowledge-base-quick-start"
}

#variable "pinecone_api_key" {
#  description = "The Pinecone API key"
#  type        = string
#  sensitive   = true
#}

variable "metadata_field" {
  type    = string
  default = "metadata"
}

variable "text_field" {
  type    = string
  default = "text"
}
