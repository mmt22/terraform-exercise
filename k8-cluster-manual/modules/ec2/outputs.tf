output "ec2-instanceid" {
  value = aws_instance.k8-master.id
}

output "nat-ec2-id" {
  value = aws_instance.k8-master.id
}

output "ec2-publicip" {
  value = aws_instance.k8-master.public_ip
}

output "ec2-privateip" {
  value = aws_instance.k8-master.private_ip
}

output "ec2-publicdns" {
  value = aws_instance.k8-master.public_dns
}

output "ec2-eni-id" {
  value = aws_instance.k8-master.primary_network_interface_id
}

output "k8master-ip" {
  value = aws_instance.k8-master.private_ip
}