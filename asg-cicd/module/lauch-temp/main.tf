resource "aws_launch_template" "template1" {
  name_prefix     = var.lt-name
  image_id        = var.ami-id
  instance_type   = var.instance_type
  vpc_security_group_ids = var.sg-ids
  user_data = var.userdata
  key_name = var.pem-key
  iam_instance_profile {
    name = var.role-name
  }
}










