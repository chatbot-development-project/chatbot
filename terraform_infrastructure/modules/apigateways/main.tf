# create api
resource "aws_api_gateway_rest_api" "grisapi" {
  name = "api_gateway"
  description = "Proxy to handle requests to our API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# create api resource
resource "aws_api_gateway_resource" "cloudapi" {
  rest_api_id = "${aws_api_gateway_rest_api.grisapi.id}"
  parent_id   = "${aws_api_gateway_rest_api.grisapi.root_resource_id}"
  path_part   = "cloudapi"
}

# define the integration
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.grisapi.id
  resource_id             = aws_api_gateway_resource.cloudapi.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "GET"  # Change this according to your Lambda function requirements
  type                    = "AWS_PROXY"
  # uri                     = aws_lambda_function.lambda_function.invoke_arn     # issues here
}

# create api get method
resource "aws_api_gateway_method" "method" {
  rest_api_id   = "${aws_api_gateway_rest_api.grisapi.id}"
  resource_id   = "${aws_api_gateway_resource.cloudapi.id}"
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

