# Project Name
variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my_project"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Availability Zones (2 zones for your setup)
variable "availability_zones" {
  description = "A list of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EC2 Instance Type
variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

# EC2 AMI ID
variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Replace with your preferred AMI ID
}

# EC2 Key Pair Name
variable "ec2_key_pair" {
  description = "The name of the EC2 key pair"
  type        = string
  default     = "my-key-pair"  # Replace with your key pair name
}

# Aurora DB Cluster Name
variable "aurora_cluster_name" {
  description = "Aurora DB Cluster Name"
  type        = string
  default     = "my-aurora-cluster"
}

# Database Engine for Aurora
variable "db_engine" {
  description = "Database engine for Aurora"
  type        = string
  default     = "aurora-mysql"
}

# Database Engine Version for Aurora
variable "db_engine_version" {
  description = "Aurora DB engine version"
  type        = string
  default     = "5.7"
}

# Database Name
variable "database_name" {
  description = "The database name"
  type        = string
  default     = "my_database"
}

# Aurora DB Master Username
variable "db_master_username" {
  description = "The master username for the database"
  type        = string
  default     = "admin"
}

# Aurora DB Port
variable "db_port" {
  description = "The port used by the Aurora DB"
  type        = number
  default     = 3306
}

# Allowed CIDR Blocks for DB access (private subnets)
variable "allowed_inbound_cidrs" {
  description = "List of CIDR blocks allowed to access the Aurora DB"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# DB Instance Type
variable "db_instance_type" {
  description = "The type of DB instances for the Aurora cluster"
  type        = string
  default     = "db.r5.large"
}

# Generate random password for DB Master
resource "random_password" "db_master_password" {
  length  = 16
  special = true
  upper   = true
  lower   = true
  number  = true
}
