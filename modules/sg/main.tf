resource "aws_security_group" "main_sg" {
  name        = "main-sg-${var.env}"
  description = "Security Group for ${var.env} environment"
  vpc_id      = var.vpc_id

  # Ingress
  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] 
    }
  }

  # Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "sg-${var.env}"
    Environment = var.env
  }
}
