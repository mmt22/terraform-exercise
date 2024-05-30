resource "aws_launch_template" "asg-lt" {
  name_prefix     = var.lt-name
  image_id        = var.ami-id
  instance_type   = var.instance_type
  vpc_security_group_ids = var.sg-ids
  key_name = var.pem-key
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.vol-size
      volume_type = "gp3"
      encrypted = true
    }
  }
  iam_instance_profile {
    name = var.role-name
  }
}