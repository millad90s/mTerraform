# bootstrap/aws

One-time setup of the AWS remote-state backend: a versioned, encrypted S3 bucket
plus a DynamoDB lock table. **This stack uses local state** (chicken-and-egg), so
run it once and keep its state safe.

```bash
terraform init
terraform apply -var state_bucket_name=milad-portfolio-tfstate
terraform output backend_hcl   # paste into live/<env>/backend.tf
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.60 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.60 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_state_bucket_name"></a> [state\_bucket\_name](#input\_state\_bucket\_name) | Globally-unique name for the S3 state bucket. | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region in which to create the state bucket and lock table. | `string` | `"eu-central-1"` | no |
| <a name="input_lock_table_name"></a> [lock\_table\_name](#input\_lock\_table\_name) | Name of the DynamoDB table used for state locking. | `string` | `"terraform-state-lock"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_backend_hcl"></a> [backend\_hcl](#output\_backend\_hcl) | Drop-in backend block for live/* stacks. |
| <a name="output_lock_table"></a> [lock\_table](#output\_lock\_table) | Name of the DynamoDB lock table. |
| <a name="output_state_bucket"></a> [state\_bucket](#output\_state\_bucket) | Name of the S3 bucket holding remote state. |
<!-- END_TF_DOCS -->