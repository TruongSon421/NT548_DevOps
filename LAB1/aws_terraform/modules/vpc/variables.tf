# Standard Variables
# provider
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws-profile" {
  description = "Local AWS Profile Name "
  type        = string
}

variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Public_subnets
variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Private_subnets
variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}




