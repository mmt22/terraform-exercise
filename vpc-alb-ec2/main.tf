resource "aws_vpc" "main" {

  cidr_block           = "31.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {

    Name = "Prod-Infra-Mumbai-VPC"

  }

}

resource "aws_subnet" "pubsubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "31.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "prod-infra-public-subnet-1a"
  }
}

resource "aws_subnet" "pubsubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "31.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "prod-infra-public-subnet-1b"
  }
}

resource "aws_subnet" "privatesubnet-1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "31.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "prod-infra-private-subnet-1a"
  }
}

resource "aws_subnet" "privatesubnet-2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "31.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
  tags = {
    Name = "prod-infra-private-subnet-1b"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "prod-infra-vpc-igw-mumbai"
  }
}

resource "aws_route_table" "prodinfra-public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" : "prodinfra-public-RT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    "Name" : "prodinfra-private-RT"
  }
}

resource "aws_route_table_association" "prod-public-subnet-1" {
  subnet_id      = aws_subnet.pubsubnet-1.id
  route_table_id = aws_route_table.prodinfra-public-RT.id
}

resource "aws_route_table_association" "prod-public-subnet-2" {
  subnet_id      = aws_subnet.pubsubnet-2.id
  route_table_id = aws_route_table.prodinfra-public-RT.id
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
  name        = "wordpress-alb-sg"
  description = "wordpress-alb-sg"
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

resource "aws_alb" "wordpress-alb" {

  name            = "wordpress-alb"
  subnets         = [aws_subnet.pubsubnet-1.id, aws_subnet.pubsubnet-2.id]
  security_groups = [aws_security_group.alb-sg.id]
  internal        = "false"
  tags = {
    Name = "wordpress-alb"
  }
}

resource "aws_lb_target_group" "wordpress-tg" {
  name     = "wordpress-tg"
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
  load_balancer_arn = aws_alb.wordpress-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }
}

###### RDS ###########

resource "aws_security_group" "wordpress-rds-sg" {
  name_prefix = "wordpress-rds-sg"
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


resource "aws_security_group" "ec2-sg" {
  name_prefix = "wordpress-ec2-sg"
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


resource "aws_db_instance" "wordpress-db" {
  engine                 = "mysql"
  db_name                = "wordpressdb"
  identifier             = "wordpressdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  storage_encrypted      = true
  publicly_accessible    = false
  username               = var.db-username
  password               = var.db-password
  vpc_security_group_ids = [aws_security_group.wordpress-rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true

  tags = {
    Name = "wordpress-db-private"
  }
}



resource "aws_instance" "Wp-Application" {
  ami                    = "ami-0cc9838aa7ab1dce7"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
  subnet_id              = aws_subnet.pubsubnet-1.id
  user_data              = file("./wordpress.sh")
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    delete_on_termination = true
    encrypted             = true
    tags = {
      "lifecyclepolicy" : "yes"
    }
  }
  tags = {
    "Name" : "Wp-Application"
    "env" : "prod"
    "os" : "AL-2023"
  }
}

resource "aws_lb_target_group_attachment" "tg_attach_1" {
  target_group_arn = aws_lb_target_group.wordpress-tg.arn
  target_id        = aws_instance.Wp-Application.id
  port             = 80
}








