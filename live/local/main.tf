module "dev_vm" {
  source = "../../modules/multipass-vm"

  name            = var.vm_name
  image           = var.image
  cpus            = var.cpus
  memory          = var.memory
  disk            = var.disk
  ssh_public_keys = [file("~/.ssh/id_ed25519.pub")]
}

output "ipv4" {
  value = module.dev_vm.ipv4
}

output "ssh_command" {
  value = "ssh ubuntu@${module.dev_vm.ipv4}"
}
