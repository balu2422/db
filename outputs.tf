output "vpc_id" {
  value = module.aurora_db_setup.vpc_id
}

output "ec2_public_ip" {
  value = module.aurora_db_setup.ec2_public_ip
}

output "aurora_endpoint" {
  value = module.aurora_db_setup.aurora_cluster_endpoint
}
