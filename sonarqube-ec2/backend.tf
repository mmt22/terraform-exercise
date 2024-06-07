terraform {
  backend "s3" {
    bucket = "terraform-remotestate-7856"
    key    = "sonarqube-ec2/terraform.tfstate"
    region = "ap-south-1"
  }
}