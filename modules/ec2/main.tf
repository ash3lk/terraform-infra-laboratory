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
              
              apt-get update -y
              apt-get install -y docker.io docker-compose awscli
              systemctl start docker
              systemctl enable docker       
              usermod -aG docker ubuntu
              sleep 5
              
              REGISTRY_URL=$(echo "${var.backend_image_url}" | cut -d'/' -f1)
              aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin $REGISTRY_URL
              DB_PASSWORD=$(aws ssm get-parameter --name "/${var.env}/rds/password" --with-decryption --query "Parameter.Value" --output text --region eu-north-1)
              
              mkdir -p /home/ubuntu/app
              cd /home/ubuntu/app
              cat <<_COMPOSE_ > docker-compose.yml
              version: '3.8'
              services:
                backend:
                  image: ${var.backend_image_url}
                  container_name: backend
                  ports:
                    - "80:8080"
                  restart: always
                  environment:
                    HTTP_PORT: "8080"
                    DB_URL: "postgres://dbadmin:$DB_PASSWORD@${var.db_endpoint}/infra_laboratory?sslmode=require"
              _COMPOSE_

              docker-compose up -d
              EOF


  tags = {
    Name        = "server-${var.env}"
    Environment = var.env
    OS          = "Ubuntu-22.04"
  }
}
 