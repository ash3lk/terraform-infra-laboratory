variable "env" {
  type        = string
  description = "dev, prod, infra"
}

variable "vpc_id" {
  type        = string
  description = "ID vpc for SG"
}

variable "allowed_ports" {
  type        = list(number)
  default     = [22, 8080]
  description = "List of allowed ingress ports"
}
