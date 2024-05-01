output "dynamodb_table_name_output" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.dynamodb-table.name
}