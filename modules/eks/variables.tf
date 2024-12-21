variable "cluster_name" {
  description = "EKS cluster name."
}

variable "cluster_version" {
  description = "EKS Kubernetes version."
  default     = "1.27"
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster."
}

variable "private_subnets" {
  description = "Private subnets for EKS cluster."
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS nodes."
  default     = "t3.medium"
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

variable "cidr_range_group_a" {
  description = "CIDR range for Group A."
  default     = "192.168.1.0/24"
}

variable "cidr_range_group_b" {
  description = "CIDR range for Group B."
  default     = "192.168.2.0/24"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket."
}

variable "eks_cluster_role_arn" {
  
}

variable "eks_node_group_role_arn" {
  
}

variable "dummy_service_role_arn" {
  
}