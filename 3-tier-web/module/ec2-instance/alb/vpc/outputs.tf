output "vpc-id" {
  value = aws_vpc.main.id
}

output "publicsub-1-id" {
  value = aws_subnet.pubsubnet-1.id
}

output "publicsub-2-id" {
  value = aws_subnet.pubsubnet-2.id
}

output "privatesub-1-id" {
  value = aws_subnet.privatesubnet-1.id
}

output "privatesub-2-id" {
  value = aws_subnet.privatesubnet-2.id
}
