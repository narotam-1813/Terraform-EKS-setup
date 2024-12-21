module "vpc" {
  source               = "./modules/vpc"
  vpc_name             = var.vpc_name
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets
  private_subnets_cidr = var.private_subnets
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "iam" {
  source = "./modules/iam"
  bucket_name = module.s3.bucket_name
  environment = "${var.vpc_name}"
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "${var.vpc_name}-eks"
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_id
  node_instance_type = var.node_instance_type
  desired_capacity  = var.desired_capacity
  max_capacity      = var.max_capacity
  min_capacity      = var.min_capacity
  cidr_range_group_a = var.cidr_range_group_a
  cidr_range_group_b = var.cidr_range_group_b
  s3_bucket_name = module.s3.bucket_name
  dummy_service_role_arn = module.iam.dummy_service_role_arn
  eks_cluster_role_arn =  module.iam.eks_cluster_role_arn
  eks_node_group_role_arn = module.iam.eks_node_group_role_arn
}