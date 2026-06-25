# live/dev

The fully-wired reference environment. GKE is the always-on cloud target (the
`helm`/`kubernetes` providers point at it); EKS, vSphere, and Proxmox are behind
`enable_*` toggles. Copy this directory's structure into `../staging` and
`../prod`, changing the backend `key`/`prefix` and sizing per environment.

```bash
cp terraform.tfvars.example terraform.tfvars   # then edit (gitignored)
terraform init      # after uncommenting a backend in backend.tf
terraform plan
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.60 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.40 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.14 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.31 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 2.1 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | ~> 0.66 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | ~> 2.8 |

## Providers

No providers.

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"eu-central-1"` | no |
| <a name="input_enable_eks"></a> [enable\_eks](#input\_enable\_eks) | n/a | `bool` | `false` | no |
| <a name="input_enable_openstack"></a> [enable\_openstack](#input\_enable\_openstack) | n/a | `bool` | `false` | no |
| <a name="input_enable_proxmox"></a> [enable\_proxmox](#input\_enable\_proxmox) | n/a | `bool` | `false` | no |
| <a name="input_enable_vsphere"></a> [enable\_vsphere](#input\_enable\_vsphere) | ---- Feature toggles (keep on-prem off in cloud CI, etc.) ---- | `bool` | `false` | no |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | n/a | `string` | `null` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | n/a | `string` | `"europe-west3"` | no |
| <a name="input_openstack_auth_url"></a> [openstack\_auth\_url](#input\_openstack\_auth\_url) | n/a | `string` | `null` | no |
| <a name="input_openstack_region"></a> [openstack\_region](#input\_openstack\_region) | n/a | `string` | `"RegionOne"` | no |
| <a name="input_openstack_tenant_name"></a> [openstack\_tenant\_name](#input\_openstack\_tenant\_name) | n/a | `string` | `null` | no |
| <a name="input_proxmox_api_token"></a> [proxmox\_api\_token](#input\_proxmox\_api\_token) | n/a | `string` | `null` | no |
| <a name="input_proxmox_endpoint"></a> [proxmox\_endpoint](#input\_proxmox\_endpoint) | n/a | `string` | `null` | no |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | n/a | `string` | `null` | no |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | n/a | `string` | `null` | no |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | ---- Provider connection ---- | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_eks_cluster_name"></a> [eks\_cluster\_name](#output\_eks\_cluster\_name) | Name of the dev EKS cluster (if enabled). |
| <a name="output_gke_cluster_name"></a> [gke\_cluster\_name](#output\_gke\_cluster\_name) | Name of the dev GKE cluster. |
<!-- END_TF_DOCS -->