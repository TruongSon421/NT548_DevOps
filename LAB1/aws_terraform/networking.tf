provider "aws" {
  profile = var.aws-profile
  region  = var.aws_region
}

# Module VPC
module "vpc" {
  source          = "./modules/vpc"
  name            = var.name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

# Module NAT Gateway
module "nat_gateway" {
  source           = "./modules/nat_gateway"
  name             = var.name
  public_subnet_ids = module.vpc.public_subnet_ids
  tags             = var.tags
}

# Module Route Tables
module "route_tables" {
  source              = "./modules/route_tables"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_ids     = module.nat_gateway.nat_gateway_ids
  custom_port         = var.custom_port
  tags                = var.tags
}

# Module Security Groups
module "security_groups" {
  source            = "./modules/security_groups"
  name              = var.name
  vpc_id            = module.vpc.vpc_id
  public_allowed_ip = var.public_allowed_ip
  tags              = var.tags
}

# Module EC2 Instances
module "ec2" {
  source                = "./modules/ec2"
  name                  = var.name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  public_sg_id          = module.security_groups.public_sg_id
  private_sg_id         = module.security_groups.private_sg_id
  public_instance_count = var.public_instance_count
  private_instance_count = var.private_instance_count
  ami                   = var.ami
  instance_type         = var.instance_type
  key_name              = var.key_name
  tags                  = var.tags
}
