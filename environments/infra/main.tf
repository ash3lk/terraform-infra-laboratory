module "vpc_infra" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-infra"
  cidr = "10.2.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.2.10.0/24", "10.2.11.0/24", "10.2.12.0/24"]
  public_subnets  = ["10.2.20.0/24", "10.2.21.0/24", "10.2.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway  = true
}
