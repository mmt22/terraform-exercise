provider "aws" {
  region = "ap-south-1"
}

resource "aws_alb" "lb1" {
  name            = "app1-cicd-alb"
  security_groups = ["sg-06dfa5c2367f1db33"]
  subnets         = ["subnet-03636e6840a6a7933", "subnet-093e8e872dc6ed5d4"]
  internal        = false
  tags = {
    Name = "app1-cicd-alb"
  }
}

resource "aws_lb_target_group" "app1-tg" {
  name     = "cicd-app1-tg"
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

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_alb.lb1.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1-tg.arn
  }
}

module "asg-lt" {

  source        = "./module/lauch-temp"
  lt-name       = "cicd-app1"
  instance_type = "t3.micro"
  ami-id        = "ami-05e00961530ae1b55"
  role-name     = "SSM-ROLE-EC2"
  pem-key       = "website"
  userdata      = filebase64("./userdata.sh")
  sg-ids        = ["sg-06dfa5c2367f1db33"]

}



module "asg-grp1" {
  source               = "./module/lauch-temp/asg-grp"
  asg-name             = "asg-grp1"
  lt-id                = module.asg-lt.id
  desired-cap          = 1
  min-cap              = 1
  max-cap              = 2
  termination_policies = ["OldestInstance"]
  target-grp-arn       = [aws_lb_target_group.app1-tg.arn]
}




