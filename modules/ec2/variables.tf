variable "env" {
  type        = string
  description = "Dev, prod, infra"
}

variable "ami_id" {
  type        = string
  description = "The AMI ID for Ubuntu 22.04"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance size"
}

variable "key_name" {
  type        = string
  description = "Name of the SSH key pair"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID where the instance will be launched"
}

variable "sg_id" {
  type        = string
  description = "Security Group ID to attach to the instance"
}
