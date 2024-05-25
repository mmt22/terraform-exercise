output "alb-tg-arn" {
  value = aws_lb_target_group.alb-tg.arn
}

output "alb-listener" {
  value = aws_lb_listener.lb-listener.arn
}

output "alb-zoneid" {
  value = aws_alb.alb.zone_id
}

output "alb-dns" {
  value = aws_alb.alb.dns_name
}