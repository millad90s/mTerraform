resource "proxmox_virtual_environment_vm" "this" {
  name        = var.name
  node_name   = var.node_name
  vm_id       = var.vm_id
  description = var.description
  tags        = var.tags

  clone {
    vm_id = var.clone_template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk.datastore_id
    interface    = var.disk.interface
    size         = var.disk.size_gb
    discard      = var.disk.discard
    iothread     = true
  }

  network_device {
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_config
        gateway = var.gateway
      }
    }

    user_account {
      username = var.ci_user
      keys     = var.ssh_public_keys
    }
  }

  lifecycle {
    ignore_changes = [
      initialization, # cloud-init only applies on first boot
    ]
  }
}
