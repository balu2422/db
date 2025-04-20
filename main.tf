terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "aurora_db_setup" {
  source = "./modules/infra"

  project_name                 = var.project_name
  region                       = var.region
  vpc_cidr                     = var.vpc_cidr
  availability_zones           = var.availability_zones
  database_name                = var.database_name
  db_engine                    = var.db_engine
  db_engine_version            = var.db_engine_version
  db_instance_type             = var.db_instance_type
  db_master_username           = var.db_master_username
  db_master_password_length    = var.db_master_password_length
  aurora_cluster_name          = var.aurora_cluster_name
  secrets_manager_secret_name  = var.secrets_manager_secret_name
  db_port                      = var.db_port
  allowed_inbound_cidrs        = var.allowed_inbound_cidrs
}

# Output values from the module
output "aurora_endpoint" {
  value       = module.aurora_db_setup.aurora_cluster_endpoint
  description = "The endpoint of the Aurora DB cluster"
}

output "aurora_reader_endpoint" {
  value       = module.aurora_db_setup.aurora_cluster_reader_endpoint
  description = "The reader endpoint of the Aurora DB cluster"
}

output "aurora_master_username" {
  value       = module.aurora_db_setup.aurora_master_username
  description = "The master username of the Aurora DB cluster"
}

output "secrets_manager_secret_arn" {
  value       = module.aurora_db_setup.secrets_manager_arn
  description = "Secrets Manager ARN containing Aurora credentials"
}

output "vpc_id" {
  value       = module.aurora_db_setup.vpc_id
  description = "The ID of the VPC"
}

output "private_subnet_ids" {
  value       = module.aurora_db_setup.private_subnet_ids
  description = "List of private subnet IDs"
}

output "public_subnet_ids" {
  value       = module.aurora_db_setup.public_subnet_ids
  description = "List of public subnet IDs"
}

output "security_group_id" {
  value       = module.aurora_db_setup.security_group_id
  description = "Aurora security group ID"
}

output "ec2_security_group_id" {
  value       = module.aurora_db_setup.ec2_security_group_id
  description = "EC2 security group ID"
}

output "ec2_public_ip" {
  value       = module.aurora_db_setup.ec2_public_ip
  description = "Public IP of the EC2 instance"
}
