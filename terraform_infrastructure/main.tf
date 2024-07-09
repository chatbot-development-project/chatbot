module "lambda_functions" {
  source = "./modules/lambdas"
}

module "api_gateway" {
  source = "./modules/apigateways"

  get_invoke_arn = module.lambda_functions.cloud_auth_invoke_arn
  post_invoke_arn = module.lambda_functions.whatsapp_input_invoke_arn
  whatsapp_input_function_name = module.lambda_functions.whatsapp_input_function_name
  cloud_auth_function_name = module.lambda_functions.cloud_auth_function_name
}

module "dynamodb" {
  source = "./modules/dynamodb" 

  process_stream_function_name = module.lambda_functions.process_stream_lambda_arn
}

module "bedrock" {
  source = "./modules/bedrock"
}