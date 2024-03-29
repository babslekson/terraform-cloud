output "rds-endpoint" {
    value = aws_db_instance.rds.endpoint
    description = "RDS endpoint"
}

output "kms_arn" {
    value        = aws_kms_key.kms-key.arn
    description  =  " Aws kms key arn"
}