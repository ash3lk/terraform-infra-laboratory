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

              set -x

            
              killall apt apt-get || true
              rm -f /var/lib/apt/lists/lock
              rm -f /var/cache/apt/archives/lock
              rm -f /var/lib/dpkg/lock*

              dpkg --configure -a

              apt-get update -y

              apt-get install -y unzip curl docker.io docker-compose || {
                echo "Falling back to official docker script..."
                curl -fsSL https://get.docker.com -o get-docker.sh
                sh get-docker.sh
                apt-get install -y docker-compose
              }
              
              systemctl start docker || true
              systemctl enable docker || true       
              groupadd docker || true
              usermod -aG docker ubuntu

              cd /tmp
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip -o awscliv2.zip
              ./aws/install

              rm -rf awscliv2.zip aws
              EOF
  tags = {
    Name        = "server-${var.env}"
    Environment = var.env
    OS          = "Ubuntu-22.04"
  }
}
 