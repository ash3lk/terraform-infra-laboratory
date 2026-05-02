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