terraform {
  backend "s3" {
    bucket         = "chatbot-statefiles-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    # dynamodb_table = "terraform-lock"
  }
}
