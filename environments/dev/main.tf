#1. AMI Lookup
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

#2. Iam Resources
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "ec2_role" {
  name = "${var.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "ssm_rds_read" {
  name        = "${var.env}-ec2-ssm-rds-read-policy"
  description = "Allows EC2 to safely fetch RDS password from SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameter",
        "ssm:GetParameters"
      ]
Resource = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.env}/rds/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_rds_read.arn
}


resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

#3. VPC
module "vpc" {
  source          = "../../modules/vpc"
  env             = var.env
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

#4. Security Group
module "sg" {
  source        = "../../modules/sg"
  env           = var.env
  vpc_id        = module.vpc.vpc_id 
  allowed_ports = var.allowed_ports
}

#5. EC2

#Docker image from ECR
data "aws_ecr_repository" "backend" {
  name = "terraform-infra-laboratory-backend"
}

module "ec2" {
  source    = "../../modules/ec2"
  backend_image_url = "${data.aws_ecr_repository.backend.repository_url}:latest"
  db_endpoint = module.rds.db_endpoint 
  env       = var.env
  ami_id    = data.aws_ami.ubuntu.id 
  key_name  = var.key_name  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name         
  subnet_id = module.vpc.public_subnets[0] 
  sg_id     = module.sg.ec2_sg_id              
}

#6. RDS
module "rds" {
  source          = "../../modules/rds"
  env             = var.env
  private_subnets = module.vpc.private_subnets
  db_sg_id        = module.sg.rds_sg_id
}

