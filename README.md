# Infrastructure as Code — milad_portfolio

Multi-platform Terraform managing virtual machines, storage, and Kubernetes
clusters across on-prem hypervisors and public clouds.

## Layout

```
.
├── bootstrap/          # one-time setup of remote state backends
│   ├── aws/            # S3 bucket + DynamoDB lock table
│   └── gcp/            # GCS bucket (with object versioning)
├── modules/            # reusable building blocks (no hardcoded env values)
│   ├── vsphere-vm/         VMs on VMware vSphere (clone from template)
│   ├── vsphere-storage/    Datastores / virtual disks on vSphere
│   ├── proxmox-vm/         QEMU/KVM VMs on Proxmox VE
│   ├── proxmox-lxc/        LXC containers on Proxmox VE
│   ├── openstack-instance/ Nova compute instances (+ optional floating IP)
│   ├── openstack-storage/  Cinder block volumes (+ optional attachment)
│   ├── eks-cluster/        Amazon EKS cluster + managed node groups
│   ├── gke-cluster/        Google GKE cluster + node pools
│   └── k8s-bootstrap/      Post-cluster addons (ingress, cert-manager, ArgoCD)
└── live/               # actual deployments that call the modules
    ├── dev/
    ├── staging/
    └── prod/
```

**Golden rule:** `modules/` are generic and reusable. Anything environment
specific (counts, sizes, IPs, project IDs) lives in `live/<env>`.

## Getting started

1. **Bootstrap state** (once per cloud):
   ```bash
   cd bootstrap/aws && terraform init && terraform apply
   cd bootstrap/gcp && terraform init && terraform apply
   ```
2. **Wire up an environment:** edit `live/dev/backend.tf` to point at the bucket
   created above, then:
   ```bash
   cd live/dev && terraform init && terraform plan
   ```

## Conventions

- Every module pins provider versions in `versions.tf`.
- Run `pre-commit run -a` before pushing (fmt, validate, tflint, terraform-docs).
- Never commit `*.tfvars` with secrets — use SOPS or environment variables.

## CI/CD

Both runners are provided — use whichever host the repo lives on:

| Host | Files | Pipeline |
|------|-------|----------|
| GitHub | `.github/workflows/*.yml` | `terraform-ci` (fmt/validate/tflint/trivy) + per-env plan |
| GitLab | `.gitlab-ci.yml` | `validate` → `security` → `plan` → manual `apply`, per env |

Both expect cloud credentials as CI secrets/variables (prefer OIDC over static
keys). `plan`/`apply` for `staging` and `prod` only activate once those `live/`
dirs contain `.tf` files.

## Providers used

| Platform | Provider |
|----------|----------|
| vSphere  | `hashicorp/vsphere` |
| Proxmox  | `bpg/proxmox` |
| OpenStack | `terraform-provider-openstack/openstack` |
| AWS/EKS  | `hashicorp/aws` |
| GCP/GKE  | `hashicorp/google` |
| K8s addons | `hashicorp/kubernetes`, `hashicorp/helm` |
