variable "public_instance_security_group_id" {
  description = "The ID of the public instance security group"
  type        = string
}

variable "private_instance_security_group_id" {
  description = "The ID of the private instance security group"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "instance_type" {
  description = "The instance type"
  type        = string
}

variable "region" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "availability_zones" {
  description = "The availability zones to deploy the VPC"
  type        = list(string)
}

variable "keypair" {
  type = string
}