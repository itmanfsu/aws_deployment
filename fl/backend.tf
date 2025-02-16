provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-bucket-tlyle-dev"
    key            = "terraform/fl-state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table-dev"
    encrypt        = true
  }
}