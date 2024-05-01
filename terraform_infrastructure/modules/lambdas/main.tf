# assume role for whatsapp input
resource "aws_iam_role" "input_assume" {
  name = var.whatsapp_input_role
  assume_role_policy = file("${path.module}/policy/assume_role.json")  # edit to the iam folder where the assume role json file is 
}

# iam policy for whatsapp input
resource "aws_iam_role_policy" "input_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy/input_policy.json")
  role = aws_iam_role.input_assume.id
}

# archive src folder for whatsapp input
data "archive_file" "input_python_code" {
  type = "zip"
  #source_dir = "./CODE/whatsapp_input/"     # archive the content of the source folder
  source_dir = "${path.module}/CODE/whatsapp_input/"
  #output_path = "./whatsapp_input.zip"  # output zip file to root path
  output_path = "${path.module}/whatsapp_input.zip"
}

# whatsapp_input lambda_function
resource "aws_lambda_function" "whatsapp_input" {
  function_name =var.whatsapp_input
  role = aws_iam_role.input_assume.arn
  handler = "whatsapp_input.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.input_python_code.output_path # Path to your ZIP file
  source_code_hash = filebase64sha256(data.archive_file.input_python_code.output_path)
}

# cloudwatch logging for whatsapp input
resource "aws_cloudwatch_log_group" "input_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.whatsapp_input.function_name}"
  retention_in_days = null   # mean never expire
}

# assume role for whatsapp output
resource "aws_iam_role" "output_assume" {
  name = var.whatsapp_output_role
  assume_role_policy = file("${path.module}/policy/assume_role.json") 
}

# iam policy for whatsapp output
resource "aws_iam_role_policy" "output_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy/output_policy.json")
  role = aws_iam_role.output_assume.id
}

# archive src folder for whatsapp output
data "archive_file" "output_python_code" {
  type = "zip"
  #source_dir = "./CODE/whatsapp_output/"     # archive the content of the source folder
  source_dir = "${path.module}/CODE/whatsapp_output/"
  #output_path = "./whatsapp_output.zip"  # output zip file to root path
  output_path = "${path.module}/whatsapp_output.zip"
}

# lambda layer for whatsapp output
resource "aws_lambda_layer_version" "my_layer" {
  filename   = "${path.module}/python.zip"
  layer_name = "Requests"
  # compatible_runtimes = ["python3.8"]
}

# whatsapp output lambda function
resource "aws_lambda_function" "whatsapp_output" {
  function_name =var.whatsapp_output
  role = aws_iam_role.output_assume.arn
  handler = "whatsapp_output.lambda_handler"
  layers  = [aws_lambda_layer_version.my_layer.arn]
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.output_python_code.output_path 
  source_code_hash = filebase64sha256(data.archive_file.output_python_code.output_path)
}

# cloud watch logging for whatsapp output lambda function
resource "aws_cloudwatch_log_group" "output_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.whatsapp_output.function_name}"
  retention_in_days = null
}
#./CODE/whatsapp_input/whatsapp_input.py

# assume role for cloudapi auth
resource "aws_iam_role" "cloud_auth_assume" {
  name = var.cloud_auth_role
  assume_role_policy = file("${path.module}/policy/assume_role.json") 
}

# iam policy for cloudapi auth
resource "aws_iam_role_policy" "cloud_auth_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy/cloud_auth_policy.json")
  role = aws_iam_role.cloud_auth_assume.id
}

# archive src folder for cloudapi auth
data "archive_file" "cloud_auth_python_code" {
  type = "zip"
  #source_dir = "./CODE/cloudapi_auth/"     # archive the content of the source folder
  source_dir = "${path.module}/CODE/cloudapi_auth/"
  #output_path = "./cloudapi_auth.zip"  # output zip file to root path
  output_path = "${path.module}/cloudapi_auth.zip"
}

# cloud auth lambda function
resource "aws_lambda_function" "cloud_auth" {
  function_name =var.cloud_auth
  role = aws_iam_role.cloud_auth_assume.arn
  handler = "cloudapi_auth.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.cloud_auth_python_code.output_path 
  source_code_hash = filebase64sha256(data.archive_file.cloud_auth_python_code.output_path)
}

# cloud watch logging for cloud auth lambda function
resource "aws_cloudwatch_log_group" "cloud_auth_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.cloud_auth.function_name}"
  retention_in_days = null
}

# assume role for process stream
resource "aws_iam_role" "process_assume" {
  name = var.process_stream_role
  assume_role_policy = file("${path.module}/policy/assume_role.json") 
}

# iam policy for process stream
resource "aws_iam_role_policy" "process_stream_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy/process_stream_policy.json")
  role = aws_iam_role.process_assume.id
}

# archive src folder for process stream
data "archive_file" "process_stream_python_code" {
  type = "zip"
  #source_dir = "./CODE/process_stream/"     # archive the content of the source folder
  source_dir = "${path.module}/CODE/process_stream/"
  #output_path = "./process_stream.zip"  # output zip file to root path
  output_path = "${path.module}/process_stream.zip"
}

# process stream lambda function
resource "aws_lambda_function" "process_stream" {
  function_name =var.process_stream
  role = aws_iam_role.process_assume.arn
  handler = "process_stream.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.process_stream_python_code.output_path 
  source_code_hash = filebase64sha256(data.archive_file.process_stream_python_code.output_path)
}

# cloud watch logging for process stream lambda function
resource "aws_cloudwatch_log_group" "process_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.process_stream.function_name}"
  retention_in_days = null
}
