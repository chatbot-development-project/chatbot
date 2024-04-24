resource "aws_dynamodb_table" "example" {
  name           = "example"
  hash_key       = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}