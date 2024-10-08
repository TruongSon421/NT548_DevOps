variable "vpc_id" {
  description = "ID of the VPC where the security groups will be created"
  type        = string
}

variable "name" {
  description = "Base name for the resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
  }
}

variable "public_allowed_ip" {
  description = "IP address or range allowed to access the public security group"
  type        = string
}

variable "custom_port" {
  description = "Custom port to allow from Public EC2 instances"
  type        = number
  default     = 8080  # Example default port, change as needed
}