
resource "aws_instance" "sonarqube-ec2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [module.ec2-sg.sg-id]
  iam_instance_profile   = var.iam_instance_profile
  availability_zone      = "ap-south-1b"
  user_data              = file("./sonarqube.sh")
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
    "Name" : "sonarqube"
    "env" : "dev"
    "os" : "ubuntu"
  }
}

module "ec2-sg" {
  source    = "./modules/sg"
  sg-name   = "sonareqube-ec2-sg"
  vpc_id    = "vpc-0d923e7ee6f36cb17"
  allow-ips = ["0.0.0.0/0", "44.195.74.221/32"]
}

resource "aws_eip" "eip1" {
  instance = aws_instance.sonarqube-ec2.id
  domain   = "vpc"
  tags = {
    "Name" : "SonarQube-EIP"
  }
}

data "aws_route53_zone" "selected" {
  name         = "pratikjoshidevopsinfo.live"
  private_zone = false
}

resource "aws_route53_record" "domainName" {
  name    = "sonar"
  type    = "A"
  zone_id = data.aws_route53_zone.selected.zone_id
  records = [aws_eip.eip1.public_ip]
  ttl     = 300
  depends_on = [
    aws_eip.eip1
  ]
}
