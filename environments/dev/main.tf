# 1. VPC
module "vpc" {
  source          = "../../modules/vpc"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

# 2. Security Group
module "sg" {
  source        = "../../modules/sg"
  env           = var.env
  vpc_id        = module.vpc.vpc_id # Берем ID из модуля VPC
  allowed_ports = [22, 80, 443]      # SSH, HTTP, HTTPS
}

# 3. EC2 instance
module "ec2" {
  source    = "../../modules/ec2"
  env       = var.env
  ami_id    = "ami-0fe8bec493a81c7da" # Ubuntu 22.04 LTS в eu-north-1
  key_name  = "your-key-name"         # Имя твоего ключа из консоли AWS
  
  subnet_id = module.vpc.public_subnets[0] # Ставим в первую публичную подсеть
  sg_id     = module.sg.sg_id              # Привязываем созданную SG
}
