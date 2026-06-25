output "state_bucket" {
  description = "Name of the GCS bucket holding remote state."
  value       = google_storage_bucket.state.name
}

output "backend_hcl" {
  description = "Drop-in backend block for live/* stacks."
  value       = <<-EOT
    terraform {
      backend "gcs" {
        bucket = "${google_storage_bucket.state.name}"
        prefix = "live/<env>"
      }
    }
  EOT
}
