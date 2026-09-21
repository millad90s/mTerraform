# multipass-vm

Local Ubuntu VM on macOS/Linux via [Multipass](https://multipass.run) (no cloud or hypervisor server needed).
Requires `multipass` and `jq` on the host.

## Usage

```hcl
module "dev_vm" {
  source = "../../modules/multipass-vm"

  name            = "dev-app-01"
  cpus            = 2
  memory          = "2G"
  disk            = "10G"
  ssh_public_keys = [file("~/.ssh/id_ed25519.pub")]
}
```

## Run it

```bash
# 1. Prerequisites (macOS)
brew install --cask multipass && brew install jq terraform
multipass version            # daemon must respond

# 2. Create the VM (from the directory that calls the module)
terraform init
terraform apply

# 3. Use it
terraform output ipv4
multipass shell dev-app-01                 # or: ssh ubuntu@<ipv4> if ssh_public_keys was set
multipass list

# 4. Remove it
terraform destroy                          # runs `multipass delete --purge`
```

## Notes

- Changing `image`, `cpus`, `memory`, `disk` or cloud-init recreates the VM (resources can't be resized in place).
- The generated cloud-init file is written to `.generated/` inside the module; add it to `.gitignore`.

## Inputs / Outputs

| Input | Default | Description |
|---|---|---|
| `name` | required | VM name |
| `image` | `24.04` | Multipass image alias or URL |
| `cpus` | `2` | vCPUs |
| `memory` | `2G` | RAM |
| `disk` | `10G` | Disk size |
| `cloud_init` | `null` | Raw cloud-init user-data |
| `ssh_public_keys` | `[]` | Keys added via cloud-init (ignored if `cloud_init` set) |

Outputs: `name`, `ipv4`, `state`.
