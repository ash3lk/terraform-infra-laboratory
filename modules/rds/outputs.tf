output "db_endpoint" {
  description = "DB adress for connection"
  value       = aws_db_instance.postgres.endpoint
}

output "db_instance_id" {
  description = "DB instance id"
  value       = aws_db_instance.postgres.id
}

output "db_name" {
  description = "DB name"
  value       = aws_db_instance.postgres.db_name
}

output "db_username" {
  description = "DB username"
  value = aws_db_instance.postgres.username
}

output "db_password" {
  description = "The generated password for the RDS instance"
  value       = random_password.db_password.result
  sensitive   = true 
}