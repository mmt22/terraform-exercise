terraform {
  backend "s3" {
    bucket = "terraform-remotestate-7856"
    key    = "k8-cluster/terraform.tfstate"
    region = "ap-south-1"
  }
}