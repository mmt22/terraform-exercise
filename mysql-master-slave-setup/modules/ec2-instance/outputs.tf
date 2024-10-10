output "ec2-ip" {

  description = "ec2-public-ip"
  value = aws_instance.master.public_ip
  
}

