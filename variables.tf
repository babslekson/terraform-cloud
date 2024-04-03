variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}
variable "preferred_number_of_public_subnets" {
  default = 2
}
variable "preferred_number_of_private_subnets" {
  default = 4
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "name" {
  type    = string
  default = "olalekan"
}

variable "keypair" {
   type = string
}
variable "ami-bastion" {
  type = string
}
variable "ami-web" {
  type = string
}

variable "ami-nginx" {
  type = string
}

variable "ami-sonar" {
  type        = string
  description = "AMI ID for the launch template"
}

variable "master_username" {
  type = string
}
variable "master_password" {
 type = string
}
variable "account_no" {
   type = string
}
variable " keypair" {
  
}
