terraform {
  backend "s3" {
    bucket = "terraform-remotestate-7856"
    key    = "/3-tier-web/terraform.tfstate"
    region = "ap-south-1"
  }
}