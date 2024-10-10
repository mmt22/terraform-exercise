resource "aws_instance" "master" {

    ami = var.ami
    instance_type = "t3.micro"
    key_name = var.key_name
    vpc_security_group_ids = [var.vpc_security_group_ids]
    subnet_id = var.subnet_id
    user_data = file(var.user_data)
    
    root_block_device {
      volume_type = "gp3"
      volume_size = var.volume_size
      delete_on_termination = "true"
    }

    tags = {
      "Name" = var.instance-name
    }

}

