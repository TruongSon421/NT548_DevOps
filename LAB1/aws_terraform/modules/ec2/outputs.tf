output "public_instance_ids" {
  description = "List of Public EC2 Instance IDs"
  value       = aws_instance.public[*].id
}

output "private_instance_ids" {
  description = "List of Private EC2 Instance IDs"
  value       = aws_instance.private[*].id
}

output "public_instance_ips" {
  description = "List of Public EC2 Instance Public IPs"
  value       = aws_instance.public[*].public_ip
}
