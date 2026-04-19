output "vpc_id" {
  value = module.vpc_infra.vpc_id
}

output "public_subnets" {
  value = module.vpc_infra.public_subnets
}

output "private_subnets" {
  value = module.vpc_infra.private_subnets
}

output "nat_public_ips" {
  value = module.vpc_infra.nat_public_ips
}