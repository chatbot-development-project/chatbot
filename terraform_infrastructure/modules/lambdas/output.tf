output "whatsapp_input_lambda_arn" {
  description = "ARN of the WhatsApp input Lambda function"
  value       = aws_lambda_function.whatsapp_input.arn
}

output "whatsapp_output_lambda_arn" {
  description = "ARN of the WhatsApp output Lambda function"
  value       = aws_lambda_function.whatsapp_output.arn
}

output "cloud_auth_lambda_arn" {
  description = "ARN of the Cloud API authentication Lambda function"
  value       = aws_lambda_function.cloud_auth.arn
}

output "process_stream_lambda_arn" {
  description = "ARN of the Process Stream Lambda function"
  value       = aws_lambda_function.process_stream.arn
}

output "cloud_auth_invoke_arn" {
  value = aws_lambda_function.cloud_auth.invoke_arn
}

output "whatsapp_input_function_name" {
  value = aws_lambda_function.whatsapp_input.function_name
}

output "cloud_auth_function_name" {
  value = aws_lambda_function.cloud_auth.function_name
}

output "whatsapp_input_invoke_arn" {
  value = aws_lambda_function.whatsapp_input.invoke_arn
}

