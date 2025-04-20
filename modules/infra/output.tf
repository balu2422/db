# VPC Information
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

# Subnet Information
output "private_subnet_a_id" {
  description = "The ID of the first private subnet"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "The ID of the second private subnet"
  value       = aws_subnet.private_b.id
}

output "public_subnet_a_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_a.id
}

# Optional Subnet CIDR Blocks (for clarity)
output "private_subnet_a_cidr" {
  description = "The CIDR block of the first private subnet"
  value       = aws_subnet.private_a.cidr_block
}

output "private_subnet_b_cidr" {
  description = "The CIDR block of the second private subnet"
  value       = aws_subnet.private_b.cidr_block
}

output "public_subnet_a_cidr" {
  description = "The CIDR block of the public subnet"
  value       = aws_subnet.public_a.cidr_block
}

# EC2 Instance Information
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2_instance.public_ip
}

# Aurora DB Cluster Information
output "aurora_cluster_id" {
  description = "The ID of the Aurora DB Cluster"
  value       = aws_rds_cluster.aurora.id
}

output "aurora_endpoint" {
  description = "The endpoint of the Aurora DB Cluster"
  value       = aws_rds_cluster.aurora.endpoint
}

output "aurora_master_username" {
  description = "The master username for the Aurora DB Cluster"
  value       = var.db_master_username
}

output "aurora_instance_ids" {
  description = "The IDs of the Aurora DB instances"
  value       = [aws_rds_cluster_instance.instance_1.id, aws_rds_cluster_instance.instance_2.id]
}

# New Output for DB Subnet Group Name
output "db_subnet_group_name" {
  description = "The name of the Aurora DB subnet group"
  value       = var.db_subnet_group_name
}
