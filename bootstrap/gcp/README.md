# bootstrap/gcp

One-time setup of the GCP remote-state backend: a versioned GCS bucket with a
lifecycle rule capping old versions. GCS provides native state locking, so no
lock table is needed. **This stack uses local state.**

```bash
terraform init
terraform apply -var project_id=my-gcp-project -var state_bucket_name=milad-portfolio-tfstate
terraform output backend_hcl   # paste into live/<env>/backend.tf
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.40 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.40 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID that will own the state bucket. | `string` | n/a | yes |
| <a name="input_state_bucket_name"></a> [state\_bucket\_name](#input\_state\_bucket\_name) | Globally-unique name for the GCS state bucket. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | GCS bucket location (region or multi-region). | `string` | `"EU"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_hcl"></a> [backend\_hcl](#output\_backend\_hcl) | Drop-in backend block for live/* stacks. |
| <a name="output_state_bucket"></a> [state\_bucket](#output\_state\_bucket) | Name of the GCS bucket holding remote state. |
<!-- END_TF_DOCS -->