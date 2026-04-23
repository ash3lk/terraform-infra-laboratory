env             = "dev"
key_name        = "my-aws-key" 
instance_type   = "t3.micro"
vpc_cidr        = "10.0.0.0/16"
azs             = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
public_subnets  = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
private_subnets = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
allowed_ports   = [22, 80, 443]
