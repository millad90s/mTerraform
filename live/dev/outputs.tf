output "gke_cluster_name" {
  description = "Name of the dev GKE cluster."
  value       = module.gke.cluster_name
}

output "eks_cluster_name" {
  description = "Name of the dev EKS cluster (if enabled)."
  value       = var.enable_eks ? module.eks[0].cluster_name : null
}
