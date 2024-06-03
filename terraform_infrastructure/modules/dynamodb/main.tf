#########################
## user_metadata table ##
#########################

# create dynamodb table and enable process stream
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "message_id"
  range_key      = "timestamp"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "message_id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "Prod"
  }
}

# enable event source mapping to allow dynamodb stream trigger process stream function
resource "aws_lambda_event_source_mapping" "trg" {
  event_source_arn = aws_dynamodb_table.dynamodb-table.stream_arn
  #function_name = aws_lambda_function.process_stream.arn
  function_name = var.process_stream_function_name
  starting_position = "LATEST"
  batch_size        = 1000
}

###############################
## user_session_record table ##
###############################

# create user_session_record table
resource "aws_dynamodb_table" "user_session_record" {
  name           = "user_session_record"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "phone_number"

  attribute {
    name = "phone_number"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "Prod"
  }
}

###################
## session_table ##
###################

# create session_table 
resource "aws_dynamodb_table" "session_table" {
  name           = "session_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "SessionId"

  attribute {
    name = "SessionId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "Prod"
  }
}