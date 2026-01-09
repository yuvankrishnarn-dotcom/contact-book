variable "project" {
  type    = string
  default = "contact-book"
}

variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnet_cidr_1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr_2" {
  type    = string
  default = "10.0.2.0/24"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "db_username" {
  type    = string
  default = "contactadmin"
}

variable "db_password" {
  type      = string
  default   = "ChangeMe123!"
  sensitive = true
}

