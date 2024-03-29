# The entire section create a certiface, public zone, and validate the certificate using DNS method

# Create the certificate using a wildcard for all the domains created in lekandevops.site
resource "aws_acm_certificate" "lekandevops" {
  domain_name       = "*.lekandevops.site"
  validation_method = "DNS"

  validation_option {
    domain_name       = "*.lekandevops.site"
    validation_domain = "lekandevops.site"
  }
}
# Creating hosted zone
resource "aws_route53_zone" "lekandevops" {
  name = "lekandevops.site"
}

resource "aws_acm_certificate_validation" "lekandevops" {
        certificate_arn         = aws_acm_certificate.lekandevops.arn
        validation_record_fqdns = [for record in aws_route53_record.lekandevops : record.fqdn]
        }
        
# selecting validation method
resource "aws_route53_record" "lekandevops" {
  for_each = {
    for dvo in aws_acm_certificate.lekandevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.lekandevops.zone_id
}

       



# create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = aws_route53_zone.lekandevops.zone_id
  name    = "tooling.lekandevops.site"
  type    = "A"

  alias {
    name                   = aws_lb.elb.dns_name
    zone_id                = aws_lb.elb.zone_id
    evaluate_target_health = true
  }
}


# create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = aws_route53_zone.lekandevops.zone_id
  name    = "wordpress.lekandevops.site"
  type    = "A"

  alias {
    name                   = aws_lb.elb.dns_name
    zone_id                = aws_lb.elb.zone_id
    evaluate_target_health = true
  }
}
