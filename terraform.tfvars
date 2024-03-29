region = "us-east-1"

vpc_cidr = "10.0.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

preferred_number_of_public_subnets  = 2
preferred_number_of_private_subnets = 4

tags = {
  Owner-Email = "olalekanbabayemi1@gmail.com"
  Managed-By  = "terraform"
}


keypair         = "keypair"
ami             = "ami-0c7217cdde317cfec"
master_username = "olalekan"
master_password = "lekan12345"
account_no      = "471112558029"