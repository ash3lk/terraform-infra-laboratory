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

              apt-get update -y
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker       
              usermod -aG docker ubuntu
              apt-get install -y awscli
              aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin ${var.backend_image_url}ер
              docker run -d -p 80:8080 ${var.backend_image_url}
              EOF


  tags = {
    Name        = "server-${var.env}"
    Environment = var.env
    OS          = "Ubuntu-22.04"
  }
}
 