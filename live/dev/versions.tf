terraform {
  required_version = ">= 1.6"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.8"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }
}
