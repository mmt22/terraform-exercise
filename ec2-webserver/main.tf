resource "aws_instance" "apache2-linux" {
  availability_zone      = "us-east-1a"
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

### Security Group Rules ####

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]          # Replace YOUR_IP_ADDRESS with the IP you want to whitelist
  security_group_id = "sg-0c01ed90f6882d3bc" # Replace with the ID of your existing security group
}










