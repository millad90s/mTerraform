# live/prod

Production environment. Mirror [`../dev`](../dev) but with production hardening:

- Separate remote-state `key`/`prefix` → `live/prod`.
- `endpoint_public_access = false` (or tightly scoped `public_access_cidrs`) for EKS.
- `enable_private_nodes = true` and `STABLE` release channel for GKE.
- On-demand capacity (no spot/preemptible) for baseline node pools.
- Real TLS certs for vSphere/Proxmox (`allow_unverified_ssl = false`, `insecure = false`).
- Require PR review + `terraform plan` approval before apply.

```bash
cp ../dev/{versions.tf,providers.tf,variables.tf,main.tf,outputs.tf} .
cp ../dev/backend.tf .   # then change key/prefix to live/prod
```
