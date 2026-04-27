output "ec_sg_id" {
  description = "Created security group ID"
  value       = aws_security_group.main_sg.id
}

output "rds_sg_id" {
   description = "Created security group ID for RDS"
  value = aws_security_group.rds_sg.id
}
