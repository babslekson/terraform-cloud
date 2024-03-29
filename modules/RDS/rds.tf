resource "aws_db_instance" "rds" {



  allocated_storage    = 10
  db_name              = "test"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds-subnet-dbgroup.id
  vpc_security_group_ids = var.db-sg                            




}

resource "aws_db_subnet_group" "rds-subnet-dbgroup" {
  name       = "rds-subnet-dbgroup"
  subnet_ids = var.private_subnets

  tags = {
    Name = "rds-subnet-dbgroup"
  }
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

resource "aws_kms_key" "kms-key" {
  description = "KMS key"
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_no}:user/terraform" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.kms-key.key_id
}

