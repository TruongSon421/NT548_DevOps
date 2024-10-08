variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of Public Subnet IDs where NAT Gateway will be deployed"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    Environment = "dev"
  }
}
