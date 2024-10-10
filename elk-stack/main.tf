module "elk-vpc" {
  source               = "./modules/vpc"
  vpc_name             = "elk-infra-vpc"
  vpc-cidr             = "27.0.0.0/16"
  public-subnet1-cidr  = "27.0.1.0/24"
  public-subnet2-cidr  = "27.0.2.0/24"
  private-subnet1-cidr = "27.0.3.0/24"
  private-subnet2-cidr = "27.0.4.0/24"
  igw-name             = "elk-infra-IGW"
  public-rt-name       = "elk-infra-public-RT"
  private-rt-name      = "elk-infra-private-RT"
}

#new lines ##
resource "aws_security_group" "elk-leadernode-sg" {
  name        = "elk-leadernode-sg"
  description = "elk-leadernode-sg"
  vpc_id      = module.elk-vpc.vpc-id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "elk-followernode-sg" {
  name        = "elk-followernode-sg"
  description = "elk-followernode-sg"
  vpc_id      = module.elk-vpc.vpc-id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


module "elk-leadernode-ec2" {
  source                 = "./modules/ec2-instances"
  region                 = "ap-south-1"
  instance_name          = "ELK-leadernode"
  instance_type          = "t3a.small"
  ami                    = "ami-02b49a24cfb95941c"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.elk-vpc.vpc-id
  subnet-id              = module.elk-vpc.publicsub-1-id
  vpc_security_group_ids = [aws_security_group.elk-leadernode-sg.id]
  userdatafile           = file("elk-setup.sh")
  volume_type            = "gp3"
  volume_size            = 12
  volume_encryption      = true
  termination-protect    = true
  source_dest_check      = true
}


module "elk-followernode-ec2" {
  source                 = "./modules/ec2-instances"
  region                 = "ap-south-1"
  instance_name          = "ELK-followernode"
  instance_type          = "t3a.small"
  ami                    = "ami-02b49a24cfb95941c"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.elk-vpc.vpc-id
  subnet-id              = module.elk-vpc.publicsub-2-id
  vpc_security_group_ids = [aws_security_group.elk-followernode-sg.id]
  userdatafile           = file("elk-setup.sh")
  volume_type            = "gp3"
  volume_size            = 12
  volume_encryption      = true
  termination-protect    = true
  source_dest_check      = true
}



resource "aws_eip" "eip1" {
  instance = module.elk-leadernode-ec2.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "elk-leadernode-EIP"
  }
}


resource "aws_eip" "eip2" {
  instance = module.elk-followernode-ec2.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "elk-followernode-EIP"
  }
}




