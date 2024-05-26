terraform {
  backend "s3" {
    bucket         = "terraform-remotestate-7856"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
  }
}