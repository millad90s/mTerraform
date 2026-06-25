output "cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.this.name
}

output "endpoint" {
  description = "Cluster control-plane endpoint."
  value       = google_container_cluster.this.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 CA cert (for kubeconfig)."
  value       = google_container_cluster.this.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "workload_identity_pool" {
  description = "Workload Identity pool of the cluster."
  value       = "${var.project_id}.svc.id.goog"
}
