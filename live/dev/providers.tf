# Credentials come from environment variables / SOPS-decrypted exports, never
# committed here. See each provider's docs for the env vars it reads.

provider "vsphere" {
  user                 = var.vsphere_user     # or VSPHERE_USER
  password             = var.vsphere_password # or VSPHERE_PASSWORD
  vsphere_server       = var.vsphere_server   # or VSPHERE_SERVER
  allow_unverified_ssl = true                 # homelab; use a real cert in prod
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint  # or PROXMOX_VE_ENDPOINT
  api_token = var.proxmox_api_token # or PROXMOX_VE_API_TOKEN
  insecure  = true
}

provider "openstack" {
  # Prefer sourcing these from an OpenStack RC file (`source openrc.sh`), which
  # sets OS_AUTH_URL / OS_USERNAME / OS_PASSWORD / OS_PROJECT_NAME / etc.
  auth_url    = var.openstack_auth_url    # or OS_AUTH_URL
  region      = var.openstack_region      # or OS_REGION_NAME
  tenant_name = var.openstack_tenant_name # or OS_PROJECT_NAME
}

provider "aws" {
  region = var.aws_region
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Helm/Kubernetes providers target the GKE cluster created in this stack.
# Adjust to the EKS cluster instead if that is your primary target.
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
  # token via `gke-gcloud-auth-plugin` / exec auth in real use.
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
  }
}
