output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_endpoint
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}