# 1. Custom VPC name instead of random
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "custom-${var.project_name}-vpc"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 2. Private Subnets (Only 2 private subnets)
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = element(var.availability_zones, 0)

  tags = {
    Name        = "${var.project_name}-private-a"
    Environment = "Dev"
    Project     = var.project_name
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = element(var.availability_zones, 1)

  tags = {
    Name        = "${var.project_name}-private-b"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 3. Public Subnet (for NAT Gateway and EC2)
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 3)
  availability_zone = element(var.availability_zones, 0)

  tags = {
    Name        = "${var.project_name}-public-a"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 4. Internet Gateway for Public Subnet (EC2 access)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-igw"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 5. NAT Gateway in Public Subnet
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name        = "${var.project_name}-nat"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 6. Route Tables
# Public route table for EC2 with IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# Private route table for Private Subnets (uses NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name        = "${var.project_name}-private-rt"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 7. Route Table Associations
# Public route table associations for EC2 subnets
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Private route table associations
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private.id
}

# 8. EC2 Instance in Public Subnet (with Internet Access)
resource "aws_instance" "ec2_instance" {
  ami             = var.ec2_ami_id
  instance_type   = var.ec2_instance_type
  subnet_id       = aws_subnet.public_a.id
  associate_public_ip_address = true
  key_name        = var.ec2_key_pair

  tags = {
    Name        = "${var.project_name}-ec2-instance"
    Environment = "Dev"
    Project     = var.project_name
  }

  security_groups = [aws_security_group.ec2_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install mysql-client -y
              EOF
}

# 9. Security Groups
# Security group for EC2 instance in public subnet (for HTTP/HTTPS access)
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Allow inbound HTTP and SSH access to EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for Aurora DB (in private subnets)
resource "aws_security_group" "aurora" {
  name_prefix = "${var.aurora_cluster_name}-sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_inbound_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.aurora_cluster_name}-sg"
    Environment = "Dev"
    Project     = var.project_name
  }
}

# 10. Aurora DB Cluster and Instances (same as original)
resource "aws_rds_cluster" "aurora" {
  cluster_identifier   = var.aurora_cluster_name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  database_name        = var.database_name
  master_username      = var.db_master_username
  master_password      = random_password.db_master_password.result
  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  skip_final_snapshot  = true
}

resource "aws_rds_cluster_instance" "instance_1" {
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.db_instance_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
}

resource "aws_rds_cluster_instance" "instance_2" {
  cluster_identifier   = aws_rds_cluster.aurora.id
  instance_class       = var.db_instance_type
  engine               = var.db_engine
  engine_version       = var.db_engine_version
}
