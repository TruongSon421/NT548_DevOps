# Public EC2 Instances
resource "aws_instance" "public" {
  count         = var.public_instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(var.public_subnet_ids, count.index)
  key_name      = var.key_name

  vpc_security_group_ids = [var.public_sg_id]

  tags = merge(
    var.tags,
    { Name = "${var.name}-public-ec2-${count.index + 1}" }
  )
}

# Private EC2 Instances
resource "aws_instance" "private" {
  count         = var.private_instance_count
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(var.private_subnet_ids, count.index)
  key_name      = var.key_name

  vpc_security_group_ids = [var.private_sg_id]

  tags = merge(
    var.tags,
    { Name = "${var.name}-private-ec2-${count.index + 1}" }
  )
}
