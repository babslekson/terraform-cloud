output "name_servers" {
  value = aws_route53_zone.lekandevops.name_servers
}
 


output "alb_dns_name" {
  value       = aws_lb.elb.dns_name
  description = "External load balance arn"
}

output "nginx-tg" {
  description = "External Load balancaer target group"
  value       = aws_lb_target_group.nginx-tg.arn
}


output "wordpress-tg" {
  description = "wordpress target group"
  value       = aws_lb_target_group.wordpress-tg.arn
}


output "tooling-tg" {
  description = "Tooling target group"
  value       = aws_lb_target_group.tooling-tg.arn
}