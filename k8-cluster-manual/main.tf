module "prod-vpc" {
  source               = "./modules/vpc"
  vpc_name             = "k8-infra-vpc"
  vpc-cidr             = "27.0.0.0/16"
  public-subnet1-cidr  = "27.0.1.0/24"
  public-subnet2-cidr  = "27.0.2.0/24"
  private-subnet1-cidr = "27.0.3.0/24"
  private-subnet2-cidr = "27.0.4.0/24"
  igw-name             = "k8-infra-IGW"
  public-rt-name       = "k8-infra-public-RT"
  private-rt-name      = "k8-infra-private-RT"
}

#new lines ##
resource "aws_security_group" "k8-master-sg" {
  name        = "k8-master-sg"
  description = "k8-master-sg"
  vpc_id      = module.prod-vpc.vpc-id

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


resource "aws_security_group" "k8-node1-sg" {
  name        = "k8-node1-sg"
  description = "k8-node1-sg"
  vpc_id      = module.prod-vpc.vpc-id

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

module "k8-master" {
  source                 = "./modules/ec2"
  region                 = "ap-south-1"
  instance_name          = "k8-master"
  instance_type          = "t3a.medium"
  ami                    = "ami-05e00961530ae1b55"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-1-id
  vpc_security_group_ids = [aws_security_group.k8-master-sg.id]
  userdatafile           = file("k8-master.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
  source_dest_check      = true
}

module "k8-node1" {
  source                 = "./modules/ec2"
  region                 = "ap-south-1"
  instance_name          = "k8-node1"
  instance_type          = "t3a.small"
  ami                    = "ami-05e00961530ae1b55"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-1-id
  vpc_security_group_ids = [aws_security_group.k8-master-sg.id]
  userdatafile           = file("k8-node.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
  source_dest_check      = true
}


module "k8-node2" {
  source                 = "./modules/ec2"
  region                 = "ap-south-1"
  instance_name          = "k8-node2"
  instance_type          = "t3a.small"
  ami                    = "ami-05e00961530ae1b55"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-2-id
  vpc_security_group_ids = [aws_security_group.k8-master-sg.id]
  userdatafile           = file("k8-node.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
  source_dest_check      = true
}

/*
module "nat-ec2" {
  source                 = "./modules/ec2"
  region                 = "ap-south-1"
  instance_name          = "nat-ec2"
  instance_type          = "t3a.small"
  ami                    = "ami-07f197c9052039d8c"
  key_name               = "website"
  iam_instance_profile   = "SSM-ROLE-EC2"
  vpc_id                 = module.prod-vpc.vpc-id
  subnet-id              = module.prod-vpc.publicsub-1-id
  vpc_security_group_ids = [aws_security_group.k8-master-sg.id]
  source_dest_check      = false
  userdatafile           = file("./nat-gw.sh")
  volume_type            = "gp3"
  volume_size            = 8
  volume_encryption      = true
  termination-protect    = true
}


resource "aws_route" "nat-instance-route" {
  route_table_id         = module.prod-vpc.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.nat-ec2.ec2-eni-id
}

resource "aws_lb_target_group_attachment" "tg_attach_1" {
  target_group_arn = module.k8-alb.alb-tg-arn
  target_id        = module.k8-node1.ec2-instanceid
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attach_2" {
  target_group_arn = module.k8-alb.alb-tg-arn
  target_id        = module.k8-node2.ec2-instanceid
  port             = 80
}

*/

resource "aws_eip" "eip1" {
  instance = module.k8-master.ec2-instanceid
  domain   = "vpc"
  tags = {
    "Name" : "k8-master-EIP"
  }
}

module "k8-alb" {
  source      = "./modules/alb"
  alb-name    = "k8-alb"
  vpcid       = module.prod-vpc.vpc-id
  subnetid    = [module.prod-vpc.publicsub-1-id, module.prod-vpc.publicsub-2-id]
  alb-sg-name = "k8-alb-sg"
  alb-tg-name = "k8-tg"
}

resource "aws_lb_listener_rule" "host_header_rule" {
  listener_arn = module.k8-alb.alb-listener
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = module.k8-alb.alb-tg-arn
  }

  condition {
    host_header {
      values = ["pratikjoshidevopsinfo.live"]
    }
  }
}

output "alb-dns" {
  value = module.k8-alb.alb-dns
}

output "alb-zone-id" {
  value = module.k8-alb.alb-zoneid
}

output "ec2-public_ip" {
  value = module.k8-master.ec2-publicip
}