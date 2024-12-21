resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_cluster_role_arn

  vpc_config {
    subnet_ids         = var.private_subnets
    endpoint_private_access = true
    endpoint_public_access  = false
  }
  
  version = var.cluster_version
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.eks_node_group_role_arn
  subnet_ids      = var.private_subnets

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }

  instance_types = [var.node_instance_type]

  depends_on = [aws_eks_cluster.eks_cluster]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "core_dns" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "kube-proxy"
}

resource "kubernetes_namespace" "group_a" {
  metadata {
    name = "${lower(replace(var.cluster_name, "_", "-"))}-group-a"
    annotations = {
      "cni.calico.org/ipv4pools" = jsonencode([var.cidr_range_group_a])
    }
  }
}

resource "kubernetes_namespace" "group_b" {
  metadata {
    name = "${lower(replace(var.cluster_name, "_", "-"))}-group-b"
    annotations = {
      "cni.calico.org/ipv4pools" = jsonencode([var.cidr_range_group_b])
    }
  }
}

resource "aws_eks_addon" "calico" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  addon_name   = "amazon-vpc-cni"
  addon_version = "v1.12.2-eksbuild.1"
}

resource "kubernetes_service_account" "group1" {
  metadata {
    name      = "dummy-service-account-group1"
    namespace = kubernetes_namespace.group_a.metadata[0].name
 
  }
  automount_service_account_token = true
}

resource "kubernetes_deployment" "dummy_service" {
  metadata {
    name      = "dummy-service"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "dummy-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "dummy-service"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.group1.metadata[0].name

        container {
          name  = "dummy-container"
          image = "amazonlinux:latest"

          env {
            name  = "S3_BUCKET"
            value = var.s3_bucket_name
          }

          command = [
            "/bin/sh",
            "-c",
            "echo Dummy service started"
          ]
        }
      }
    }
  }
}