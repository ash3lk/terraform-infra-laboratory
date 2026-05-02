# 1. AMI Lookup
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. VPC
module "vpc" {
  source          = "../../modules/vpc"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# 3. Security Group
module "sg" {
  source        = "../../modules/sg"
  env           = var.env
  vpc_id        = module.vpc.vpc_id 
  allowed_ports = var.allowed_ports
}

# 4. EC2
module "ec2" {
  source    = "../../modules/ec2"
  env       = var.env
  ami_id    = data.aws_ami.ubuntu.id 
  key_name  = var.key_name           
  
  subnet_id = module.vpc.public_subnets[0] 
  sg_id     = module.sg.sg_id              
}

#5. RDS
module "rds" {
  source          = "../../modules/rds"
  env             = var.env
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.sg.rds_sg_id
}