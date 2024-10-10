terraform {
  backend "s3" {
    bucket = "terraform-backend-4242"
    key    = "tf-statefiles/mysql-master-slave.tf"
    region = "us-east-1"
  }
}
