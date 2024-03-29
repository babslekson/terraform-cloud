output "ALB-sg" {
  value = aws_security_group.olalekan["ext-alb-sg"].id
}


output "IALB-sg" {
  value = aws_security_group.olalekan["int-alb-sg"].id
}


output "bastion-sg" {
  value = aws_security_group.olalekan["bastion-sg"].id
}


output "nginx-sg" {
  value = aws_security_group.olalekan["nginx-sg"].id
}


output "web-sg" {
  value = aws_security_group.olalekan["webserver-sg"].id
}


output "datalayer-sg" {
  value = aws_security_group.olalekan["datalayer-sg"].id
}