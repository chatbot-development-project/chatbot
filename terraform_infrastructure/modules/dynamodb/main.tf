resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "user_metadata"
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

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
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
