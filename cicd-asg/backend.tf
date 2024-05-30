terraform {
  backend "s3" {
    bucket = "terraform-remotestate-7856"
    key    = "cicd-asg/terraform.tfstate"
    region = "ap-south-1"
  }
}