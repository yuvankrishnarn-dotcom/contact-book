################################
# Project
################################
variable "project" {
  type        = string
  description = "Project name used for tagging and naming"
  default     = "contact-book"
}

################################
# AWS
################################
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "ap-south-1"
}

################################
# Networking
################################
variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  type        = string
  description = "CIDR for first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  type        = string
  description = "CIDR for second public subnet"
  default     = "10.0.2.0/24"
}

################################
# EC2
################################
variable "instance_type" {
  type        = string
  description = "EC2 instance type for backend"
  default     = "t3.micro"
}

################################
# Database
################################
variable "db_username" {
  type        = string
  description = "PostgreSQL master username"
  sensitive   = true
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "PostgreSQL master password"
  sensitive   = true
  default     = "ChangeMe123!" # acceptable for demo; replace in prod
}

