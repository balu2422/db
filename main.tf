provider "aws" {
  region = "us-east-1"
}

module "infra" {
  source = "./modules/infra"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  ec2_instance_type   = var.ec2_instance_type
  ec2_ami_id          = var.ec2_ami_id
  ec2_key_pair        = var.ec2_key_pair
  aurora_cluster_name = var.aurora_cluster_name
  db_engine           = var.db_engine
  db_engine_version   = var.db_engine_version
  database_name       = var.database_name
  db_master_username  = var.db_master_username
  db_port             = var.db_port
  allowed_inbound_cidrs = var.allowed_inbound_cidrs
  db_instance_type    = var.db_instance_type
}
