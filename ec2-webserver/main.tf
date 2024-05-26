resource "aws_instance" "apache2-linux" {

  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t3.micro"
  key_name               = "website"
  vpc_security_group_ids = ["sg-06dfa5c2367f1db33"]
  iam_instance_profile   = "SSM-ROLE-EC2"
  availability_zone      = "ap-south-1a"
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

    "Name" : "apache2-linux-1"
    "env" : "dev"
    "os" : "ubuntu"
  }

}

resource "aws_instance" "apache2-linux-2" {

  ami                    = "ami-0f58b397bc5c1f2e8"
  instance_type          = "t3.micro"
  key_name               = "website"
  vpc_security_group_ids = ["sg-06dfa5c2367f1db33"]
  iam_instance_profile   = "SSM-ROLE-EC2"
  availability_zone      = "ap-south-1a"
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

    "Name" : "apache2-linux-2"
    "env" : "prod"
    "os" : "ubuntu"
  }

}

### Security Group Rules whitelist ####











