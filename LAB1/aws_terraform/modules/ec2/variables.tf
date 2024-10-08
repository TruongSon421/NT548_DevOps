variable "name" {
  description = "Name prefix for EC2 instances"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  type        = list(string)
}

variable "public_sg_id" {
  description = "ID of the Public EC2 Security Group"
  type        = string
}

variable "private_sg_id" {
  description = "ID of the Private EC2 Security Group"
  type        = string
}

variable "public_instance_count" {
  description = "Number of Public EC2 Instances"
  type        = number
  default     = 1
}

variable "private_instance_count" {
  description = "Number of Private EC2 Instances"
  type        = number
  default     = 1
}

variable "ami" {
  description = "AMI ID for EC2 Instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
  }
}
