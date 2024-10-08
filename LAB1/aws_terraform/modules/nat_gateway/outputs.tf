output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.nat_gateway[*].id
}

output "nat_eips" {
  description = "List of Elastic IPs for NAT Gateways"
  value       = aws_eip.nat_eip[*].public_ip
}
