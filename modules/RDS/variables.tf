variable "db_username" {
  type        = string
  description = "The db user name"
}


variable "db_password" {
  type        = string
  description = "The db password"
}

variable "db-sg" {
  type = list
  description = "The DB security group"
}

variable "private_subnets" {
  type        = list
  description = "Private subnets for DB subnets group"
}


variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}
variable "account_no" {
    
}