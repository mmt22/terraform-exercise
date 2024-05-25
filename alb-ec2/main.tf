resource "aws_instance" "webapp1" {
  ami                    = "ami-0cc9838aa7ab1dce7"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
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
    "Name" : "webapp1"
    "env" : "dev"
    "os" : "AL-2023"
  }
}


resource "aws_alb" "webapp-alb" {

  name            = "webapp-alb"
  subnets         = ["subnet-03636e6840a6a7933", "subnet-0d9a0ab4b3a8501ca"]
  security_groups = ["sg-06dfa5c2367f1db33"]
  internal        = "false"
  tags = {
    Name = "webapp-alb"
  }
}

resource "aws_lb_target_group" "webapp-tg" {
  name     = "terraform-webapp-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0d923e7ee6f36cb17"
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

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_alb.webapp-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-tg.arn
  }
}


resource "aws_lb_target_group_attachment" "app_tg_attach_1" {
  target_group_arn = aws_lb_target_group.webapp-tg.arn
  target_id        = aws_instance.webapp1.id
  port             = 80
}


resource "aws_security_group" "webapp-rds-sg" {
  name_prefix = "webapp-rds-sg"
  vpc_id      = "vpc-0d923e7ee6f36cb17"
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
  subnet_ids = ["subnet-03636e6840a6a7933", "subnet-0d9a0ab4b3a8501ca"]

  tags = {
    Name = "rds-subnet-group"
  }
}


resource "aws_db_instance" "webapp-db" {
  engine                 = "mysql"
  db_name                = "webappdb"
  identifier             = "webappdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp3"
  publicly_accessible    = false
  username               = var.db-username
  password               = var.db-password
  vpc_security_group_ids = [aws_security_group.webapp-rds-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true

  tags = {
    Name = "webapp-db-private"
  }
}

output "alb_endpoint" {
  value = aws_alb.webapp-alb.dns_name
}


