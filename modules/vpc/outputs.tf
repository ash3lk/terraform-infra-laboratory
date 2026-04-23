output "vpc_id" {
  description = "created vpc id"
  value       = module.vpc_logic.vpc_id
}

output "public_subnets" {
  description = "public subnets id list"
  value       = module.vpc_logic.public_subnets
}

output "private_subnets" {
  description = "private subnets id list"
  value       = module.vpc_logic.private_subnets
}
