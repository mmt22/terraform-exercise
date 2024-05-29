output "id" {
  value = aws_launch_template.template1.id
}

output "sg-id" {
  value = [aws_launch_template.template1.vpc_security_group_ids]
}






