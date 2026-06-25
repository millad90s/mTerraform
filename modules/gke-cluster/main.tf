# VPC-native regional cluster. The default node pool is removed immediately so
# that all pools are managed explicitly via google_container_node_pool.
resource "google_container_cluster" "this" {
  project  = var.project_id
  name     = var.name
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = var.release_channel
  }

  # VPC-native networking.
  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name != "" ? var.pods_range_name : null
    services_secondary_range_name = var.services_range_name != "" ? var.services_range_name : null
  }

  # Workload Identity — preferred way to grant pods GCP IAM.
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.enable_private_nodes ? var.master_ipv4_cidr_block : null
  }

  resource_labels = var.resource_labels

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_container_node_pool" "this" {
  for_each = var.node_pools

  project  = var.project_id
  name     = each.key
  cluster  = google_container_cluster.this.id
  location = var.region

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = each.value.machine_type
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    preemptible  = each.value.preemptible
    spot         = each.value.spot
    labels       = each.value.labels

    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  lifecycle {
    ignore_changes = [node_count]
  }
}
