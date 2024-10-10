output "master-sg-id" {

    description = "master-sg-id"
    value = aws_security_group.sg.id
  
}

output "slave-sg-id" {

    description = "master-sg-id"
    value = aws_security_group.sg.id  
}