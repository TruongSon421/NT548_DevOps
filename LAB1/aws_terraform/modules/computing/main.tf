# Filter existing ami (image) on aws for ec2 instace
data "aws_ami" "ec2_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    # values = ["amzn2-ami-hvm-*-gp2"]
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_key_pair" "keypair" {
  key_name   = var.keypair
  public_key = file(var.keypair)
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.ec2_ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.keypair.key_name

  security_groups = [var.public_instance_security_group_id]

  subnet_id = var.public_subnet_ids[0]

  user_data = filebase64("${path.module}/userdata/public-instance.sh")

  tags = merge(
    # local.common_tags,
    {
      Name = "public-instance"
    }
  )
}

resource "aws_instance" "private" {
  ami           = data.aws_ami.ec2_ami.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.keypair.key_name

  security_groups = [var.private_instance_security_group_id]

  subnet_id = var.private_subnet_ids[0]

  tags = merge(
    # local.common_tags,
    {
      Name = "private-instance"
    }
  )
}