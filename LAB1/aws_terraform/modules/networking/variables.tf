variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "instance_type" {
  type = string
}

variable "availability_zones" {
  description = "The availability zones to deploy the VPC"
  type        = list(string)
}
