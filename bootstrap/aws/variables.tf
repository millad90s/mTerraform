variable "aws_region" {
  description = "AWS region in which to create the state bucket and lock table."
  type        = string
  default     = "eu-central-1"
}

variable "state_bucket_name" {
  description = "Globally-unique name for the S3 state bucket."
  type        = string
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking."
  type        = string
  default     = "terraform-state-lock"
}
