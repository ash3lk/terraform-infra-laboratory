output "sg_id" {
  description = "Created security group ID"
  value       = aws_security_group.main_sg.id
}
