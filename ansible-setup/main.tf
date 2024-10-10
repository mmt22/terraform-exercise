module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "ansible"
  instance_count = 3

  ami                    = "ami-005fc0f236362e99f"
  instance_type          = "t3.micro"
  key_name               = "contact"
  monitoring             = false
  vpc_security_group_ids = ["sg-0391abc6a8bd933a9"]
  subnet_id              = "subnet-0a431561fc03bda6f"
  user_data = file("./ansible-install.sh")
  iam_instance_profile = "SSM-EC2-ROLE"


  tags = {
    Terraform   = "true"
    Environment = "ansible"
  }
}













