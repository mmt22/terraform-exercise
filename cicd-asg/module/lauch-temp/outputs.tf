output "lt-id" {
  value = aws_launch_template.asg-lt.id
}

output "lt-sg" {
  value = [aws_launch_template.asg-lt.vpc_security_group_ids] 
}


