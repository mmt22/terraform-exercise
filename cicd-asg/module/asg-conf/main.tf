resource "aws_autoscaling_group" "autoscale" {

  name                  = var.asg-name
  desired_capacity      = var.desired-cap
  min_size              = var.min-cap
  max_size              = var.max-cap
  health_check_type     = "EC2"
  termination_policies  = var.termination_policies
  availability_zones = var.asg-azs
  target_group_arns = var.target-grp-arn
  default_cooldown = 150
  launch_template {
    id      =  var.lt-id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "${var.asg-name}-ASG"
    propagate_at_launch = true
  }
  
}