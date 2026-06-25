# Remote state. Uncomment ONE backend after running the matching bootstrap stack.
#
# AWS (see bootstrap/aws output `backend_hcl`):
# terraform {
#   backend "s3" {
#     bucket         = "milad-portfolio-tfstate"
#     key            = "live/dev/terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "terraform-state-lock"
#     encrypt        = true
#   }
# }
#
# GCP (see bootstrap/gcp output `backend_hcl`):
# terraform {
#   backend "gcs" {
#     bucket = "milad-portfolio-tfstate"
#     prefix = "live/dev"
#   }
# }
