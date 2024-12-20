#############################
## WHATSAPP INPUT  #########
#############################

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


#############################
## WHATSAPP OUTPUT  #########
#############################

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

# lambda layer for whatsapp output and delay_message
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

  environment {
    variables = {
      ACCESS_TOKEN = var.access_token_evn
      PHONE_NUMBER_ID = var.phone_number_id_env
    }
  }
}

# cloud watch logging for whatsapp output lambda function
resource "aws_cloudwatch_log_group" "output_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.whatsapp_output.function_name}"
  retention_in_days = null
}
#./CODE/whatsapp_input/whatsapp_input.py



#############################
## CLOUD AUTH       #########
#############################

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


#############################
## PROCESS STREAM   #########
#############################

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

# Random string resource
resource "random_string" "rando" {
  length  = 6
  special = false
  upper   = false
}

# Create an S3 Bucket to store the langchain layer
resource "aws_s3_bucket" "langchain_layer_bucket" {
  bucket = "langchain-bucket-${random_string.rando.result}"
  tags = {
    Name = "Lambda Layer S3 Bucket"
  }
}

# Upload the lambda_layer.zip to the S3 Bucket
resource "aws_s3_object" "upload_layer" {
  bucket = aws_s3_bucket.langchain_layer_bucket.bucket
  key    = "langchain_layer.zip"
  source = "${path.module}/langchain_layer.zip"  # Path to your local zip file
}

# Create a Lambda Layer from the s3 bucket
resource "aws_lambda_layer_version" "langchain_layer" {
  layer_name  = "langchain_layer"
  s3_bucket   = aws_s3_bucket.langchain_layer_bucket.bucket
  s3_key      = aws_s3_object.upload_layer.key
}

# process stream lambda function
resource "aws_lambda_function" "process_stream" {
  function_name =var.process_stream
  role = aws_iam_role.process_assume.arn
  handler = "process_stream.lambda_handler"
  layers  = [aws_lambda_layer_version.langchain_layer.arn]
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.process_stream_python_code.output_path 
  source_code_hash = filebase64sha256(data.archive_file.process_stream_python_code.output_path)

  environment {
    variables = {
      KNOWLEDGE_BASE_ID = var.knowledege_base_evn
    }
  }
}

# cloud watch logging for process stream lambda function
resource "aws_cloudwatch_log_group" "process_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.process_stream.function_name}"
  retention_in_days = null
}





#############################
### delay_message   #########
#############################

# assume role for delay_message
resource "aws_iam_role" "delay_assume" {
  name = var.delay_message_role
  assume_role_policy = file("${path.module}/policy/assume_role.json") 
}

# iam policy for delay_message
resource "aws_iam_role_policy" "delay_policy" {
  name = var.lambda_iam_policy_name
  policy = file("${path.module}/policy/delay_policy.json")
  role = aws_iam_role.delay_assume.id
}

# archive src folder for delay_message
data "archive_file" "delay_message_python_code" {
  type = "zip"
  source_dir = "${path.module}/CODE/delay_message/"
  output_path = "${path.module}/delay_message.zip"
}

# NOTE the request layer resource created in the whatsapp output section would also be used for the delay_message function

# whatsapp output lambda function
resource "aws_lambda_function" "delay_message" {
  function_name =var.delay_message
  role = aws_iam_role.delay_assume.arn
  handler = "delay_message.lambda_handler"
  layers  = [aws_lambda_layer_version.my_layer.arn] # request layer would be ref here 
  runtime = var.Lruntime
  timeout = var.Ltimeout
  filename = data.archive_file.delay_message_python_code.output_path 
  source_code_hash = filebase64sha256(data.archive_file.delay_message_python_code.output_path)

  environment {
    variables = {
      ACCESS_TOKEN = var.access_token_evn
      PHONE_NUMBER_ID = var.phone_number_id_env
    }
  }
}

# cloud watch logging for delay_message lambda function
resource "aws_cloudwatch_log_group" "delay_lambda_logging" {
  name = "/aws/lambda/${aws_lambda_function.delay_message.function_name}"
  retention_in_days = null
}
