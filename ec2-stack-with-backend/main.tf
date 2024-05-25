provider "aws" {
  region = "ap-south-1"
}

module "ec2-Instance1" {
  source                 = "./module/ec2-instance"
  region                 = "ap-south-1"
  instance_name          = "apache-webserver-1"
  instance_type          = "t3.micro"
  ami                    = "ami-0f58b397bc5c1f2e8"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = "vpc-0d923e7ee6f36cb17"
  subnet-id              = "subnet-0d9a0ab4b3a8501ca"
  vpc_security_group_ids = ["sg-06dfa5c2367f1db33"]
  userdatafile           = file("./apache2.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
}


resource "aws_s3_bucket" "backend-bucket" {
  bucket = "terraform-remotestate-7856"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}