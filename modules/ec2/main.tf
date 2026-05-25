resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  
  key_name      = var.key_name

  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = true

user_data = <<-EOF
#!/bin/bash
exec > /var/log/user_data.log 2>&1
set -e

apt-get update -y
apt-get install -y docker.io docker-compose awscli

systemctl enable docker
systemctl start docker

usermod -aG docker ubuntu

# wait docker
until docker info >/dev/null 2>&1; do
  sleep 1
done

# ECR login
REGISTRY_URL=$(echo "${var.backend_image_url}" | cut -d'/' -f1)

aws ecr get-login-password --region eu-north-1 \
  | docker login --username AWS --password-stdin $REGISTRY_URL

# get DB password
DB_PASSWORD=$(aws ssm get-parameter \
  --name "/${var.env}/rds/db_password" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text \
  --region eu-north-1)

# app folder
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# docker-compose file
cat > docker-compose.yml <<COMPOSE
version: "3.8"

services:
  backend:
    image: ${var.backend_image_url}
    container_name: backend
    restart: always
    ports:
      - "80:8080"
    environment:
      HTTP_PORT: 8080
      DB_URL: postgres://dbadmin:$${DB_PASSWORD}@${var.db_endpoint}/infra_laboratory_db?sslmode=require
COMPOSE

# run app
docker-compose pull
docker-compose up -d
EOF
 



  tags = {
    Name        = "server-${var.env}"
    Environment = var.env
    OS          = "Ubuntu-22.04"
  }
}
 