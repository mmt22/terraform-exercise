
resource "aws_security_group" "alb-sg" {
  name        = var.alb-sg-name
  description = "alb-sg"
  vpc_id      = var.vpcid

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

resource "aws_alb" "alb" {

  name            = var.alb-name
  subnets         = var.subnetid
  security_groups = [aws_security_group.alb-sg.id]
  internal        = "false"
  tags = {
    Name = var.alb-name
  }
}

resource "aws_lb_target_group" "alb-tg" {
  name     = var.alb-tg-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpcid
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
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}
