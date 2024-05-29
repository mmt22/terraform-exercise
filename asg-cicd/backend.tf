terraform {
  backend "s3" {
    bucket = "terraform-remotestate-7856"
    key    = "asg-cicd/terraform.tfstate"
    region = "ap-south-1"
  }
}

