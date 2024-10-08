output "public_route_table_id" {
  description = "ID of the Public Route Table"
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "List of Private Route Table IDs"
  value       = aws_route_table.private[*].id
}
