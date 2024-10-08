# Security Group for Public EC2 Instances
resource "aws_security_group" "public_sg" {
  name        = "${var.name}-public-sg"
  description = "Allow SSH from specific IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from allowed IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.public_allowed_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-public-sg" }
  )
}

# Security Group for Private EC2 Instances
resource "aws_security_group" "private_sg" {
  name        = "${var.name}-private-sg"
  description = "Allow SSH from Public EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH from Public EC2"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.public_sg.id]
  }

  # Additional ingress rule for other ports if needed
  ingress {
    description      = "Custom port from Public EC2"
    from_port        = var.custom_port
    to_port          = var.custom_port
    protocol         = "tcp"
    security_groups  = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}-private-sg" }
  )
}
