terraform {
  backend "s3" {
    bucket = "terraform-backend-4242"
    key    = "tf-statefiles/import-tf.tfstate"
    region = "us-east-1"

  }
}