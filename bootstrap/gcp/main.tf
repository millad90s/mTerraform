# Creates the remote-state backend for GCP-hosted stacks (GKE, etc.).
# GCS supports object versioning + native state locking, so no separate
# lock table is required.

resource "google_storage_bucket" "state" {
  name     = var.state_bucket_name
  project  = var.project_id
  location = var.location

  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 10
    }
    action {
      type = "Delete"
    }
  }

  labels = {
    managed_by = "terraform"
    purpose    = "terraform-remote-state"
  }
}
