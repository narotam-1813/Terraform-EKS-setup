output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

output "dummy_service_role_arn" {
  value = aws_iam_role.dummy_service_role.arn
}