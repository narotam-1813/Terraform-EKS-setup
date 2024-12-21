variable "region" {
  description = "AWS region"
  default = "ap-south-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}
variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes."
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Desired number of nodes."
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of nodes."
  default     = 3
}

variable "min_capacity" {
  description = "Minimum number of nodes."
  default     = 1
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "cluster_version" {
  description = "Version of Kubernetes for the EKS cluster"
  type        = string
  default     = "1.27"
}

variable "cidr_range_group_a" {
  description = "CIDR range for Group A"
  default     = "192.168.1.0/24"
}

variable "cidr_range_group_b" {
  description = "CIDR range for Group B"
  default     = "192.168.2.0/24"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}