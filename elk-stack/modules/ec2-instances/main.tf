resource "aws_instance" "elk-node" {
    instance_type = var.instance_type
    ami = var.ami
    key_name = var.key_name
    iam_instance_profile = var.iam_instance_profile
    subnet_id = var.subnet-id
    vpc_security_group_ids = var.vpc_security_group_ids
    user_data = var.userdatafile
    source_dest_check = var.source_dest_check
    root_block_device {
      volume_type = var.volume_type
      volume_size = var.volume_size
      encrypted = var.volume_encryption
    }
    disable_api_termination = var.termination-protect
    tags = {
      "Name":var.instance_name
    }
}