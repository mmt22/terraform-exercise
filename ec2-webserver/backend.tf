terraform {
  backend "s3" {
    bucket         = "terraform-remotestate-7856"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "ap-south-1"
  }
}