module "vpc_prod" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-prod"
  cidr = "10.1.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets = ["10.1.10.0/24", "10.1.11.0/24", "10.1.12.0/24"]
  public_subnets  = ["10.1.20.0/24", "10.1.21.0/24", "10.1.22.0/24"]

  enable_nat_gateway = true
  single_nat_gateway  = true
}