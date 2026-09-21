locals {
  env  = "dev"
  tags = { Environment = "dev", ManagedBy = "terraform", Project = "milad-portfolio" }
}

# ---------------------------------------------------------------------------
# GKE — always-on reference cloud target for the dev environment.
# ---------------------------------------------------------------------------
module "gke" {
  source = "../../modules/gke-cluster"

  project_id      = var.gcp_project_id
  name            = "${local.env}-gke"
  region          = var.gcp_region
  release_channel = "REGULAR"
  resource_labels = { environment = local.env }

  node_pools = {
    default = {
      machine_type   = "e2-standard-2"
      min_node_count = 1
      max_node_count = 3
      spot           = true # cheap for dev
    }
  }
}

# Post-cluster addons installed into the GKE cluster above.
module "k8s_addons" {
  source = "../../modules/k8s-bootstrap"

  ingress_nginx = { enabled = true }
  cert_manager  = { enabled = true }
  argocd        = { enabled = false }
  falco         = { enabled = true }

  depends_on = [module.gke]
}

# ---------------------------------------------------------------------------
# EKS — optional in dev (toggle with enable_eks).
# ---------------------------------------------------------------------------
module "eks" {
  source = "../../modules/eks-cluster"
  count  = var.enable_eks ? 1 : 0

  cluster_name = "${local.env}-eks"
  subnet_ids   = [] # supply from a VPC stack/data source before enabling
  tags         = local.tags

  node_groups = {
    default = {
      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
      desired_size   = 2
      min_size       = 1
      max_size       = 3
    }
  }
}

# ---------------------------------------------------------------------------
# vSphere VM — optional homelab workload (toggle with enable_vsphere).
# ---------------------------------------------------------------------------
module "vsphere_app_vm" {
  source = "../../modules/vsphere-vm"
  count  = var.enable_vsphere ? 1 : 0

  name       = "${local.env}-app-01"
  datacenter = "Datacenter"
  cluster    = "Cluster"
  datastore  = "datastore1"
  network    = "VM Network"
  template   = "ubuntu-2204-template"
  num_cpus   = 2
  memory_mb  = 4096
}

# ---------------------------------------------------------------------------
# Proxmox VM — optional homelab workload (toggle with enable_proxmox).
# ---------------------------------------------------------------------------
module "proxmox_app_vm" {
  source = "../../modules/proxmox-vm"
  count  = var.enable_proxmox ? 1 : 0

  name              = "${local.env}-app-01"
  node_name         = "pve"
  clone_template_id = 9000
  cores             = 2
  memory_mb         = 4096

  disk = {
    datastore_id = "local-lvm"
    size_gb      = 32
  }
}

# ---------------------------------------------------------------------------
# OpenStack instance + data volume — optional (toggle with enable_openstack).
# ---------------------------------------------------------------------------
module "openstack_app_vm" {
  source = "../../modules/openstack-instance"
  count  = var.enable_openstack ? 1 : 0

  name        = "${local.env}-app-01"
  image_name  = "ubuntu-22.04"
  flavor_name = "m1.small"
  key_pair    = "dev-key"
  networks    = [{ name = "private" }]

  security_groups  = ["default"]
  floating_ip_pool = "public"
}

module "openstack_storage" {
  source = "../../modules/openstack-storage"
  count  = var.enable_openstack ? 1 : 0

  volumes = {
    "${local.env}-data" = {
      size_gb     = 50
      volume_type = "ssd"
      instance_id = module.openstack_app_vm[0].id
      device      = "/dev/vdb"
    }
  }
}
