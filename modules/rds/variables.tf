variable "env" {
  type = string
}

variable "private_subnets" {
  type = list(string)
  description = "Private subnets list"
}

variable "db_sg_id" {
  type = string
  description = "ID Security Group allowing access to the database"
}