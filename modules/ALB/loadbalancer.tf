#External Load balancer for reverse proxy nginx
resource "aws_lb" "elb" {
  name               = var.name
  internal           = false
  security_groups    = [var.public-sg]
  subnets = [var.public-sbn-1, var.public-sbn-2, ]
  

  tags = merge(var.tags,
        {
            Name = format("%s-elb", var.name)
            },
  )
  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}
#  target group for reverse proxy
resource "aws_lb_target_group" "nginx-tg" {
  name         = "nginx-tg"
  port         = 443
  protocol     = "HTTPS"
  vpc_id       = var.vpc_id
  health_check {
    enabled             = "true"
    interval            =  10
    path                = "/healthcheck"
    port                = 443
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    } 
}

 # Route traffic from external load balancer to reverse proxy target group

resource "aws_lb_listener" "elb-listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.lekandevops.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }
}
#Internal Load Balancers for webservers
resource "aws_lb" "ilb" {

  name               = "ilb"
  internal           = "true"
  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.private-sg]
  subnets            = [var.private-sbn-1, var.private-sbn-2, ]
  

  tags = {
    Environment = "production"
  }
}
# target group for tooling
resource "aws_lb_target_group" "tooling-tg" {
  name         = "tooling-tg"
  port         = 443
  protocol     = "HTTPS"
  vpc_id       = var.vpc_id
  health_check {
    enabled             = "true"
    interval            =  10
    path                = "/healthcheck"
    port                = 443
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    } 
}

# target group for wordpress
resource "aws_lb_target_group" "wordpress-tg" {
  name         = "wordpress-tg"
  port         = 443
  protocol     = "HTTPS"
  vpc_id       = var.vpc_id
  health_check {
    enabled             = "true"
    interval            =  10
    path                = "/healthcheck"
    port                = 443
    protocol            = "HTTPS"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    } 
}

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ilb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.lekandevops.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }
}
# listener rule for tooling target
resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tg.arn
  }

  condition {
    host_header {
      values = ["tooling.lekandevops.site"]
    }
  }
}







