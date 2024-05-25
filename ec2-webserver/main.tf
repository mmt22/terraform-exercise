resource "aws_instance" "apache2-linux" {

  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t3.micro"
  key_name               = "website"
  vpc_security_group_ids = ["sg-06dfa5c2367f1db33"]
  iam_instance_profile   = "SSM-ROLE-EC2"
  availability_zone      = "ap-south-1a"
  user_data              = file("./apache2.sh")
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

    "Name" : "apache2-linux"
    "env" : "dev"
    "os" : "ubuntu"
  }

}


resource "aws_instance" "nginx-linux" {

  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t3.micro"
  key_name               = "website"
  vpc_security_group_ids = ["sg-06dfa5c2367f1db33"]
  iam_instance_profile   = "SSM-ROLE-EC2"
  availability_zone      = "ap-south-1b"
  user_data              = file("./nginx.sh")
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

    "Name" : "nginx-linux"
    "env" : "dev"
    "os" : "ubuntu"
  }

}


resource "aws_instance" "apache2-linux-2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1a"
  user_data              = file("./apache2.sh")
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
    "Name" : "apache2-linux-2"
    "env" : "dev"
    "os" : "ubuntu"
  }


}

### Security Group Rules ####
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]          # Replace YOUR_IP_ADDRESS with the IP you want to whitelist
  security_group_id = "sg-06dfa5c2367f1db33" # Replace with the ID of your existing security group
}


resource "aws_lb" "example" {
  name               = "terraform-webapplication"
  load_balancer_type = "application"
  subnets            = ["subnet-093e8e872dc6ed5d4", "subnet-03636e6840a6a7933"]
  security_groups    = var.vpc_security_group_ids
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "webapplication" {
  name     = "terraform-webapp-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id = "vpc-0d923e7ee6f36cb17"
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

resource "aws_alb" "webapp-alb" {

    name = "webapp-alb"
    subnets = [ "subnet-03636e6840a6a7933","subnet-0d9a0ab4b3a8501ca" ]
    security_groups = ["sg-06dfa5c2367f1db33"]
    internal = "false"
    tags = {
    Name = "webapp-alb"
  }
}

resource "aws_alb_target_group" "webapp-tg" {
    name = "Webapp-TG"
    port = 80
    protocol = "HTTP"
    vpc_id = "vpc-0d923e7ee6f36cb17"
      health_check {
    interval            = 30
    path                = "/"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "Webapp-TG"
  }
}








