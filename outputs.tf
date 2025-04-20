output "vpc_id" {
  value = module.infra.vpc_id
}

output "ec2_public_ip" {
  value = module.infra.ec2_public_ip
}

output "aurora_endpoint" {
  value = module.infra.aurora_endpoint
}
