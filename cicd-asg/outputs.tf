output "alb-dns" {
  value = aws_alb.cicd-alb.dns_name
}

output "alb-zoneid" {
  value = aws_alb.cicd-alb.zone_id
}






