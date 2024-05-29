output "ec2-instanceid" {
  value = aws_instance.nginx1.id
}

output "ec2-publicip" {
  value = aws_instance.nginx1.public_ip
}

output "ec2-privateip" {
  value = aws_instance.nginx1.private_ip
}

output "ec2-publicdns" {
  value = aws_instance.nginx1.public_dns
}

output "ec2-eni-id" {
  value = aws_instance.nginx1.primary_network_interface_id
}


