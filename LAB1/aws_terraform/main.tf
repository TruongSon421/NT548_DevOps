terraform {
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

# Networking 
module "networking" {
  source             = "./modules/networking"
  region             = var.region
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  instance_type      = var.instance_type
  availability_zones = var.availability_zones
}

# Security Group
module "security" {
  source            = "./modules/security"
  vpc_id            = module.networking.vpc_id
  my_workstation_ip = var.my_workstation_ip
}

# EC2
module "computing" {
  source = "./modules/computing"
  public_instance_security_group_id  = module.security.public_instance_security_group_id
  private_instance_security_group_id = module.security.private_instance_security_group_id
  public_subnet_ids = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  vpc_id                             = module.networking.vpc_id
  instance_type                      = var.instance_type
  region                             = var.region
  availability_zones                 = var.availability_zones
  keypair                            = var.keypair
}
