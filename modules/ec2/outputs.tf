output "public_ip" {
  description = "Public ip"
  value       = aws_instance.web.public_ip
}

output "instance_id" {
  description = "Created instance id"
  value       = aws_instance.web.id
}
