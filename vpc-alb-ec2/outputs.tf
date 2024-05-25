output "alb_endpoint" {
  value = aws_alb.wordpress-alb.dns_name
}
output "rds_endpoint" {
  value = aws_db_instance.wordpress-db.endpoint
}

output "ec2-publicdns" {
  value = aws_instance.Wp-Application.public_ip
}



