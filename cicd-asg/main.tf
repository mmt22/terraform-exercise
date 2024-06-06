provider "aws" {
  region = "ap-south-1"
}

/// ALB BLOCK Starts Here !!!

resource "aws_alb" "cicd-alb" {
  name            = "cicd-alb"
  security_groups = ["sg-06dfa5c2367f1db33"]
  subnets         = ["subnet-03636e6840a6a7933", "subnet-093e8e872dc6ed5d4", "subnet-0d9a0ab4b3a8501ca"]
  internal        = false
  tags = {
    Name = "cicd-asg-Alb"
  }
}

resource "aws_lb_target_group" "cicd-tg-80" {
  name     = "cicd-tg"
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


resource "aws_lb_target_group" "cicd-tg-443" {
  name     = "cicd-tg-443"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "vpc-0d923e7ee6f36cb17"
  health_check {
    path                = "/"
    protocol            = "HTTPS"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_alb.cicd-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cicd-tg-80.arn
  }
}


resource "aws_lb_listener" "lb-listener2" {
  load_balancer_arn = aws_alb.cicd-alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = "arn:aws:acm:ap-south-1:339713077529:certificate/4fd2291f-7b9d-46c3-8b99-2e9b95814cdb"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cicd-tg-443.arn
  }
}


resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.lb-listener.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = ["pratikjoshidevopsinf.live", "*.pratikjoshidevopsinfo.live"]
    }
  }
}

/// END OF ALB BLOCK ///

module "asg-lt" {

  source        = "./module/lauch-temp"
  lt-name       = "cicd-lt"
  ami-id        = "ami-08504310369dd4c87"
  instance_type = "t3.micro"
  sg-ids        = ["sg-06dfa5c2367f1db33"]
  pem-key       = "website"
  role-name     = "SSM-ROLE-EC2"
  vol-size      = "10"

}


module "asg-grp" {

  source               = "./module/asg-conf"
  asg-name             = "pratikjoshidevopsinfo.live"
  lt-id                = module.asg-lt.lt-id
  desired-cap          = 2
  min-cap              = 2
  max-cap              = 2
  termination_policies = ["Default"]
  target-grp-arn       = [aws_lb_target_group.cicd-tg-80.arn, aws_lb_target_group.cicd-tg-443.arn]
}


resource "aws_route53_record" "record1" {
  zone_id = "Z0967691LB69I1DTJREY"
  name    = "pratikjoshidevopsinfo.live"
  type    = "A"
  alias {
    name                   = aws_alb.cicd-alb.dns_name
    zone_id                = aws_alb.cicd-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "record2" {
  zone_id = "Z0967691LB69I1DTJREY"
  name    = "www.pratikjoshidevopsinfo.live"
  type    = "A"
  alias {
    name                   = aws_alb.cicd-alb.dns_name
    zone_id                = aws_alb.cicd-alb.zone_id
    evaluate_target_health = true
  }
}



