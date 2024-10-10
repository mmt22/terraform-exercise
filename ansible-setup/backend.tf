terraform {
  backend "s3" {
    bucket = "terraform-backend-4242"
    key    = "tf-statefiles/terraform.tfstate"
    region = "us-east-1"
  }
}
