output "api_gateway_url" {
  description = "URL of the deployed API Gateway"
  value       = aws_api_gateway_deployment.prod_stage.invoke_url
}

output "get_method_url" {
  value = aws_api_gateway_integration.get_lambda_integration.uri
}

output "post_method_url" {
  value = aws_api_gateway_integration.post_lambda_integration.uri
}

output "whatsapp_input_function_name" {
  value = aws_lambda_permission.apigw_input_lambda.function_name
}

output "cloud_auth_function_name" {
  value = aws_lambda_permission.apigw_cloudauth_lambda.function_name
}

