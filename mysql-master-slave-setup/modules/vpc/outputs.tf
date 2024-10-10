output "vpc_id" {

    description = "vpc-id"
    value = aws_vpc.main.id
  
}

output "public-subnet-1" {

    description = "public-subnet-1-id"
    value = aws_subnet.pubsubnet-1.id
  
}

output "public-subnet-2" {

    description = "public-subnet-1-id"
    value = aws_subnet.pubsubnet-2.id
  
}