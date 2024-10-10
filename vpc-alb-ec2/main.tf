
resource "aws_vpc" "main" {

  cidr_block           = "14.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {

    Name = "COE-Energy-metering-Infra-VPC"

  }

}

resource "aws_subnet" "pubsubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "COE-Energy-metering-public-subnet-1a"
  }
}

resource "aws_subnet" "pubsubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "COE-Energy-metering-public-subnet-1b"
  }
}

resource "aws_subnet" "privatesubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "COE-Energy-metering-private-subnet-1a"
  }
}

resource "aws_subnet" "privatesubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "14.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "COE-Energy-metering-private-subnet-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "COE-Energy-metering-vpc-igw-mumbai"
  }
}

resource "aws_route_table" "COE-Energy-metering-public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" : "COE-Energy-metering-public-RT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    "Name" : "COE-Energy-metering-private-RT"
  }
}



resource "aws_eip" "nat_gw_eip" {
  domain = "vpc"
  tags = {
    "Name" : "COE-Energy-metering-EIP"
  }
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw_eip.id
  subnet_id     = aws_subnet.pubsubnet-1.id
  tags = {
    Name = "COE-Energy-metering-NAT-GW"
  }
}

resource "aws_route_table_association" "prod-public-subnet-1" {
  subnet_id      = aws_subnet.pubsubnet-1.id
  route_table_id = aws_route_table.COE-Energy-metering-public-RT.id
}

resource "aws_route_table_association" "prod-public-subnet-2" {
  subnet_id      = aws_subnet.pubsubnet-2.id
  route_table_id = aws_route_table.COE-Energy-metering-public-RT.id
}

resource "aws_route_table_association" "prod-private-subnet-1" {
  subnet_id      = aws_subnet.privatesubnet-1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "prod-private-subnet-2" {
  subnet_id      = aws_subnet.privatesubnet-2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "alb-sg" {
  name        = "COE-Energy-metering-alb-sg"
  description = "COE-Energy-metering-alb-sg"
  vpc_id      = aws_vpc.main.id

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

resource "aws_alb" "COE-Energy-metering-alb" {

  name                       = "COE-Energy-metering-alb"
  subnets                    = [aws_subnet.pubsubnet-1.id, aws_subnet.pubsubnet-2.id]
  security_groups            = [aws_security_group.alb-sg.id]
  internal                   = "false"
  enable_deletion_protection = true
  tags = {
    Name = "COE-Energy-metering-alb"
  }
}

resource "aws_lb_target_group" "COE-Energy-metering-tg" {
  name     = "COE-Energy-metering-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_alb.COE-Energy-metering-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.COE-Energy-metering-tg.arn
  }
}

/*###### RDS ###########

resource "aws_security_group" "COE-Energy-metering-rds-sg" {
  name_prefix = "COE-Energy-metering-rds-sg"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 3306
    to_port     = 3306
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

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.privatesubnet-1.id, aws_subnet.privatesubnet-2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

*/

resource "aws_security_group" "vpn-sg" {
  name_prefix = "COE-Energy-metering-vpn-sg"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}




resource "aws_security_group" "ec2-sg" {
  name_prefix = "COE-Energy-metering-ec2-sg"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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


resource "aws_security_group" "ec2-db-sg" {
  name_prefix = "COE-Energy-metering-db-sg"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
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



resource "aws_instance" "COE-VPN-Server" {
  ami                    = "ami-09b0a86a2c84101e1"
  instance_type          = "t3a.small"
  key_name               = "COE-energy-metering-bastion-server"
  vpc_security_group_ids = [aws_security_group.vpn-sg.id]
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
  subnet_id              = aws_subnet.pubsubnet-1.id
  user_data              = file("./vpn.sh")
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
    tags = {
      "lifecyclepolicy" : "yes"
    }
  }
  tags = {
    "Name" : "COE-VPN-Server"
    "env" : "prod"
    "os" : "Ubuntu-22.04"
  }
}

resource "aws_instance" "coe-application" {
  ami                    = "ami-09b0a86a2c84101e1"
  instance_type          = "t3a.large"
  key_name               = "COE-energy-metering-app-server"
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
  subnet_id              = aws_subnet.privatesubnet-1.id
  user_data              = file("./userdata.sh")
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
    tags = {
      "lifecyclepolicy" : "yes"
    }
  }
  tags = {
    "Name" : "COE-App-Server"
    "env" : "prod"
    "os" : "Ubuntu-22.04"
  }
}


resource "aws_instance" "COE-DB-Server" {
  ami                    = "ami-09b0a86a2c84101e1"
  instance_type          = "t3.large"
  key_name               = "COE-energy-metering-db-server"
  vpc_security_group_ids = [aws_security_group.ec2-db-sg.id]
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
  subnet_id              = aws_subnet.privatesubnet-1.id
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
    tags = {
      "lifecyclepolicy" : "yes"
    }
  }
  tags = {
    "Name" : "COE-DB-Server"
    "env" : "prod"
    "os" : "Ubuntu-22.04"
  }
}


resource "aws_lb_target_group_attachment" "tg_attach_1" {
  target_group_arn = aws_lb_target_group.COE-Energy-metering-tg.arn
  target_id        = aws_instance.coe-application.id
  port             = 80
}












