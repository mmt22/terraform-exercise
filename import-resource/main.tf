resource "aws_vpc" "prod-vpc" {

  cidr_block           = "11.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "prod-oregon-vpc-vpc"
  }

}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.128.0/20"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-private1-us-west-2a"
  }


}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.144.0/20"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-private2-us-west-2b"
  }


}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.160.0/20"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-private3-us-west-2c"
  }


}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.0.0/20"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-pubic1-us-west-2a"
  }


}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.16.0/20"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-public2-us-west-2a"
  }


}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.prod-vpc.id
  cidr_block              = "11.0.32.0/20"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "prod-oregon-vpc-subnet-public3-us-west-2c"
  }


}

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.prod-vpc.id

  tags = {
    Name = "prod-oregon-vpc-igw"
  }
}

# Route Table for Public Subnet

resource "aws_route_table" "default_rt" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name : "prod-oregon-public-rt"
    default : "yes"
  }


}

resource "aws_route_table" "private-rt1" {
  vpc_id = aws_vpc.prod-vpc.id


  tags = {
    Name = "prod-oregon-vpc-rtb-private1-us-west-2a"
  }
}

resource "aws_route_table" "private-rt2" {
  vpc_id = aws_vpc.prod-vpc.id


  tags = {
    Name = "prod-oregon-vpc-rtb-private2-us-west-2b"
  }
}

resource "aws_route_table" "private-rt3" {
  vpc_id = aws_vpc.prod-vpc.id


  tags = {
    Name = "prod-oregon-vpc-rtb-private3-us-west-2c"
  }
}


resource "aws_security_group" "alb-sg" {
  vpc_id = aws_vpc.prod-vpc.id
  name   = "public-access-sg"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPv4 addresses
  }

}


resource "aws_security_group" "default-sg" {
  vpc_id = aws_vpc.prod-vpc.id
  name   = "default"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow from all IPv4 addresses
  }
}

resource "aws_instance" "webserver" {
  instance_type          = "t3.micro"
  ami                    = "ami-05134c8ef96964280"
  key_name               = "contact"
  iam_instance_profile   = "SSM-EC2-ROLE"
  vpc_security_group_ids = [aws_security_group.alb-sg.id]
  subnet_id              = aws_subnet.public1.id
  user_data              = file("./nginx.sh")
  tags = {
    Name : "nginx-webserver"
    tf-made : "yes"
  }
}


resource "aws_lb" "alb" {
  name               = "tf-demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name : "tf-demo-alb"
    terraform : "true"
  }
}

resource "aws_alb_target_group" "tg" {

  name             = "demo-alb-tf"
  vpc_id           = aws_vpc.prod-vpc.id
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  port             = "80"
  target_type      = "instance"

}

resource "aws_lb_target_group_attachment" "tg-attach" {
  target_group_arn = aws_alb_target_group.tg.arn
  target_id        = aws_instance.webserver.id
  port             = 80
}

resource "aws_lb_listener" "lb-listener" {
  default_action {
    type             = "forward"                   # Action type: forward traffic
    target_group_arn = aws_alb_target_group.tg.arn # ARN of the target group
  }

  load_balancer_arn = aws_lb.alb.arn

}


output "alb_dns_name" {

  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name

}

output "ec2_public_ip" {

  description = "The public IP address of the EC2 instance"
  value       = aws_instance.webserver.public_ip # This references the EC2's public IP

}

