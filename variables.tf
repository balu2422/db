variable "project_name" {
  type        = string
  default     = "my_project"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "ec2_key_pair" {
  type        = string
  default     = "my-key-pair"
}

variable "aurora_cluster_name" {
  type        = string
  default     = "my-aurora-cluster"
}

variable "db_engine" {
  type        = string
  default     = "aurora-mysql"
}

variable "db_engine_version" {
  type        = string
  default     = "5.7"
}

variable "database_name" {
  type        = string
  default     = "my_database"
}

variable "db_master_username" {
  type        = string
  default     = "admin"
}

variable "db_port" {
  type        = number
  default     = 3306
}

variable "allowed_inbound_cidrs" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_instance_type" {
  type        = string
  default     = "db.r5.large"
}
