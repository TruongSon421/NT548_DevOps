resource "aws_eip" "nat_eip" {
  count = length(var.public_subnet_ids)
  vpc   = true

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-eip-${count.index + 1}" }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.public_subnet_ids)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]

  tags = merge(
    var.tags,
    { Name = "${var.name}-nat-gateway-${count.index + 1}" }
  )
}
