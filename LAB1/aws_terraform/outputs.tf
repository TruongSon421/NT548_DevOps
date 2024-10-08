output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.nat_gateway.nat_gateway_ids
}

output "public_route_table_id" {
  description = "ID of the Public Route Table"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_ids" {
  description = "List of Private Route Table IDs"
  value       = module.route_tables.private_route_table_ids
}

output "public_sg_id" {
  description = "ID of the Public EC2 Security Group"
  value       = module.security_groups.public_sg_id
}

output "private_sg_id" {
  description = "ID of the Private EC2 Security Group"
  value       = module.security_groups.private_sg_id
}

output "public_instance_ids" {
  description = "List of Public EC2 Instance IDs"
  value       = module.ec2.public_instance_ids
}

output "private_instance_ids" {
  description = "List of Private EC2 Instance IDs"
  value       = module.ec2.private_instance_ids
}

output "public_instance_ips" {
  description = "List of Public EC2 Instance Public IPs"
  value       = module.ec2.public_instance_ips
}
