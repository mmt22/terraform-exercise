
###### ASG GROUP #########


resource "aws_autoscaling_group" "autoscale" {

  name                  = var.asg-name
  desired_capacity      = var.desired-cap
  min_size              = var.min-cap
  max_size              = var.max-cap
  health_check_type     = "EC2"
  termination_policies  = var.termination_policies
  vpc_zone_identifier = var.zone-ids
  target_group_arns = var.target-grp-arn
  launch_template {
    id      = var.lt-id
    version = "$Latest"
  }
}
