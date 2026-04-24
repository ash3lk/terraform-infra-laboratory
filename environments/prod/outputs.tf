output "vpc_id" {
  value = module.vpc_prod.vpc_id
}

output "public_subnets" {
  value = module.vpc_prod.public_subnets
}

output "private_subnets" {
  value = module.vpc_prod.private_subnets
}

