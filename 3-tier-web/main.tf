provider "aws" {
  region = "ap-south-1"
}

module "prod-vpc" {
  source               = "./module/ec2-instance/alb/vpc"
  vpc_name             = "mmt-infra-vpc"
  vpc-cidr             = "27.0.0.0/16"
  public-subnet1-cidr  = "27.0.1.0/24"
  public-subnet2-cidr  = "27.0.2.0/24"
  private-subnet1-cidr = "27.0.3.0/24"
  private-subnet2-cidr = "27.0.4.0/24"
  igw-name             = "mmt-infra-IGW"
  public-rt-name       = "mmt-infra-public-RT"
  private-rt-name      = "mmt-infra-private-RT"
}

resource "aws_security_group" "ec2-sg" {
  name        = "webapp-sg"
  description = "alb-sg"
  vpc_id      = module.prod-vpc.vpc-id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  userdatafile           = file("./nginx.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
}

module "ec2-Instance2" {
  source                 = "./module/ec2-instance"
  region                 = "ap-south-1"
  instance_name          = "apache2-webserver"
  instance_type          = "t3.micro"
  ami                    = "ami-0f58b397bc5c1f2e8"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-2-id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  userdatafile           = file("./apache2.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
}

resource "aws_eip" "eip1" {
  instance = module.ec2-Instance1.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "Nginx-EIP"
  }
}

resource "aws_eip" "eip2" {
  instance = module.ec2-Instance2.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "Apache2-EIP"
  }
}

module "wp-alb" {
  source      = "./module/ec2-instance/alb"
  alb-name    = "wpapp-alb"
  vpcid       = module.prod-vpc.vpc-id
  subnetid    = [module.prod-vpc.publicsub-1-id, module.prod-vpc.publicsub-2-id]
  alb-sg-name = "wpapp-alb-sg"
  alb-tg-name = "wpapp-tg"
}

resource "aws_lb_target_group_attachment" "tg_attach_1" {
  target_group_arn = module.wp-alb.alb-tg-arn
  target_id        = module.ec2-Instance1.ec2-instanceid
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach_2" {
  target_group_arn = module.wp-alb.alb-tg-arn
  target_id        = module.ec2-Instance2.ec2-instanceid
  port             = 80
}

resource "aws_lb_listener_rule" "host_header_rule" {
  listener_arn = module.wp-alb.alb-listener
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = module.wp-alb.alb-tg-arn
  }

  condition {
    host_header {
      values = ["pratikjoshidevopsinfo.live"]
    }
  }
}

output "alb-dns" {
  value = module.wp-alb.alb-dns
}

output "alb-zone-id" {
  value = module.wp-alb.alb-zoneid
}
