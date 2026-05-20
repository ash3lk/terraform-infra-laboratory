output "ec2_sg_id" {
  description = "Created security group ID for EC2"
  value       = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
   description = "Created security group ID for RDS"
  value = aws_security_group.rds_sg.id
}
