variable "env" {
  type        = string
  description = "Dev,prod,infra"
}

variable "key_name" {
  type        = string
  description = "SSH key name in AWS console"
}

variable "vpc_cidr" {
  type        = string
  description = "Main CIDR block for vpc"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones list"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR for private subnets"
}

variable "allowed_ports" {
  type        = list(number)
  description = "SG allowed ports"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro" 
  description = "EC2 instance type"
}
