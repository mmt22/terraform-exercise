terraform {
  backend "s3" {
    bucket         = "terraform-remotestate-7856"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
  }
}


