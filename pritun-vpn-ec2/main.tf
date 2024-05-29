provider "aws" {
  region = "ap-south-1"
}

module "ec2-Instance1" {
  source                 = "./module/ec2-instance"
  region                 = "ap-south-1"
  instance_name          = "nginx-webserver"
  instance_type          = "t3.micro"
  ami                    = "ami-0f58b397bc5c1f2e8"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-1-id
  vpc_security_group_ids = ["sg-09f86f4ed77a942dd"]
  userdatafile           = file("./nginx.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
}

resource "aws_eip" "eip3" {
  instance = module.ec2-Instance1.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "Pritunl-VPN-EIP"
  }
}







