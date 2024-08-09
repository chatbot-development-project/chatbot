# create api
resource "aws_api_gateway_rest_api" "grisapi" {
  name = var.api_name
  description = "Proxy to handle requests to our API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# create api resource
resource "aws_api_gateway_resource" "cloudapi" {
  rest_api_id = "${aws_api_gateway_rest_api.grisapi.id}"
  parent_id   = "${aws_api_gateway_rest_api.grisapi.root_resource_id}"
  path_part   = var.resource_name
}

# create the Request validator for the get method
resource "aws_api_gateway_request_validator" "request_validator" {
  name                        = "requestvalidator"
  rest_api_id                 = aws_api_gateway_rest_api.grisapi.id
  validate_request_parameters = true
}

# create api get method
resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.grisapi.id}"
  resource_id   = "${aws_api_gateway_resource.cloudapi.id}"
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.hub.challenge" = false
    "method.request.querystring.hub.mode" = false
    "method.request.querystring.hub.verify_token" = false
  }

  request_validator_id = aws_api_gateway_request_validator.request_validator.id
}

# create api post method
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.grisapi.id}"
  resource_id   = "${aws_api_gateway_resource.cloudapi.id}"
  http_method   = "POST"
  authorization = "NONE"
}

# define the lambda integration for the get method
resource "aws_api_gateway_integration" "get_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.grisapi.id
  resource_id             = aws_api_gateway_resource.cloudapi.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"  # Change this according to your Lambda function requirements
  type                    = "AWS_PROXY"
  # uri                     = aws_lambda_function.cloud_auth.invoke_arn
  uri                   = var.get_invoke_arn
}

# define the lambda integration for the post method
resource "aws_api_gateway_integration" "post_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.grisapi.id
  resource_id             = aws_api_gateway_resource.cloudapi.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"  # Change this according to your Lambda function requirements
  type                    = "AWS"
  # uri                     = aws_lambda_function.whatsapp_input.invoke_arn
  uri             = var.post_invoke_arn
}

# define the api stage
resource "aws_api_gateway_deployment" "prod_stage" {
  depends_on  = [aws_api_gateway_integration.get_lambda_integration, aws_api_gateway_integration.post_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.grisapi.id
  stage_name  = var.api_stage_name
}

# permission for apigateway to execute whatsapp input lambda function
resource "aws_lambda_permission" "apigw_input_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  # function_name = aws_lambda_function.whatsapp_input.function_name
  function_name = var.whatsapp_input_function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.grisapi.execution_arn}/*/POST/${var.resource_name}"    #use variable to subsitute for the cloudapi(resource)
}

# permission for apigateway to execute whatsapp cloud auth lambda function
resource "aws_lambda_permission" "apigw_cloudauth_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  # function_name = aws_lambda_function.cloud_auth.function_name
  function_name = var.cloud_auth_function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.grisapi.execution_arn}/*/GET/${var.resource_name}"    #use variable to subsitute for the cloudapi(resource)
}

# assume role for api gateway
resource "aws_iam_role" "api_gateway_assume" {
  name = "apigatewayrole"
  assume_role_policy = file("${path.module}/policy/api_gateway_role.json")  # edit to the iam folder where the assume role json file is
}

# iam policy for the api gateway
resource "aws_iam_role_policy" "api_gateway_policy" {
  name = "apigatewaypolicy"
  policy = file("${path.module}/policy/api_gateway_policy.json")
  role = aws_iam_role.api_gateway_assume.id
}

# cloud watch logging for api gateway
resource "aws_cloudwatch_log_group" "api_gateway_logging" {
  name = "/aws/apigateway/${aws_api_gateway_rest_api.grisapi.id}"
  retention_in_days = null
}
