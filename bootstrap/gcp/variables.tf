variable "project_id" {
  description = "GCP project ID that will own the state bucket."
  type        = string
}

variable "location" {
  description = "GCS bucket location (region or multi-region)."
  type        = string
  default     = "EU"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the GCS state bucket."
  type        = string
}
