variable "env" {
  type        = string
  description = "dev, prod, infra"
}

variable "vpc_cidr" {
  type        = string
}

variable "public_subnets" {
  type        = list(string)
}

variable "private_subnets" {
  type        = list(string)
}

variable "azs" {
  type    = list(string)
  default = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}
