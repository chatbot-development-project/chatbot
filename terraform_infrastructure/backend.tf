terraform {
  backend "s3" {
    bucket         = "chatbot-statefiles"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "terraform-lock"
  }
}
