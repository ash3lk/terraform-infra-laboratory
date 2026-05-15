resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  
  key_name      = var.key_name

  iam_instance_profile = var.iam_instance_profile

  associate_public_ip_address = true

  tags = {
    Name        = "server-${var.env}"
    Environment = var.env
    OS          = "Ubuntu-22.04"
  }
}
 