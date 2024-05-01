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

  global_secondary_index {
    name               = "UserTitleIndex"
    hash_key           = "message_id"
    range_key          = "timestamp"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "KEYS_ONLY"  # Corrected projection_type
    non_key_attributes = []
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
