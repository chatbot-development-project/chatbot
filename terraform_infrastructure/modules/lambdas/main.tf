# assume role for whatsapp input
resource "aws_iam_role" "input_assume" {
  name = var.whatsapp_input_role
  assume_role_policy = file("${path.module}/assume_role.json")  # edit to the iam folder where the assume role json file is 
}

# iam policy for whatsapp input
resource "aws_iam_role_policy" "input_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/input_policy.json")
  role = aws_iam_role.input_assume.id
}

# assume role for whatsapp output
resource "aws_iam_role" "output_assume" {
  name = var.whatsapp_output_role
  assume_role_policy = file("${path.module}/assume_role.json")  # edit to the iam folder where the assume role json file is
}

# iam policy for whatsapp output
resource "aws_iam_role_policy" "output_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/output_policy.json")
  role = aws_iam_role.output_assume.id
}

#./CODE/whatsapp_input/whatsapp_input.py
#

# assume role for cloudapi auth
resource "aws_iam_role" "cloud_auth_assume" {
  name = var.cloud_auth_role
  assume_role_policy = file("${path.module}/assume_role.json")  # edit to the iam folder where the assume role json file is
}

# iam policy for cloudapi auth
resource "aws_iam_role_policy" "cloud_auth_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/cloud_auth_policy.json")
  role = aws_iam_role.cloud_auth_assume.id
}

# assume role for process stream
resource "aws_iam_role" "process_assume" {
  name = var.process_stream_role
  assume_role_policy = file("${path.module}/assume_role.json")  # edit to the iam folder where the assume role json file is
}

# iam policy for process stream
resource "aws_iam_role_policy" "process_stream_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/process_stream_policy.json")
  role = aws_iam_role.process_assume.id
}


# archive src folder for whatsapp input
data "archive_file" "input_python_code" {
  type = "zip"
  source_dir = "../src/"     # archive the content of the source folder
  output_path = "../src.zip"  # output zip file to root path
}

# archive src folder for whatsapp output
data "archive_file" "output_python_code" {
  type = "zip"
  source_dir = "../whatsapp_output/"     # archive the content of the source folder
  output_path = "../whatsapp_output.zip"  # output zip file to root path
}

# archive src folder for cloudapi auth
data "archive_file" "cloud_auth_python_code" {
  type = "zip"
  source_dir = "../cloudapi_auth/"     # archive the content of the source folder
  output_path = "../cloudapi_auth.zip"  # output zip file to root path
}

# archive src folder for process stream
data "archive_file" "process_stream_python_code" {
  type = "zip"
  source_dir = "../process_stream/"     # archive the content of the source folder
  output_path = "../process_stream.zip"  # output zip file to root path
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

# whatsapp output lambda function
resource "aws_lambda_function" "whatsapp_output" {
  function_name =var.whatsapp_output
  role = aws_iam_role.output_assume.arn
  handler = "whatsapp_output.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.output_python_code.output_path # Path to your ZIP file
  source_code_hash = filebase64sha256(data.archive_file.output_python_code.output_path)
}

# cloud auth lambda function
resource "aws_lambda_function" "cloud_auth" {
  function_name =var.cloud_auth
  role = aws_iam_role.cloud_auth_assume.arn
  handler = "cloudapi_auth.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.cloud_auth_python_code.output_path # Path to your ZIP file
  source_code_hash = filebase64sha256(data.archive_file.cloud_auth_python_code.output_path)
}

# process stream lambda function
resource "aws_lambda_function" "process_stream" {
  function_name =var.process_stream
  role = aws_iam_role.process_assume.arn
  handler = "process_stream.lambda_handler"
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.process_stream_python_code.output_path # Path to your ZIP file
  source_code_hash = filebase64sha256(data.archive_file.process_stream_python_code.output_path)
}