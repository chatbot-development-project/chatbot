variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  default     = "user_metadata"
}

variable "process_stream_function_name" {
  description = "function name for the process stream"
}
