output "state_bucket" {
  description = "Name of the S3 bucket holding remote state."
  value       = aws_s3_bucket.state.id
}

output "lock_table" {
  description = "Name of the DynamoDB lock table."
  value       = aws_dynamodb_table.lock.name
}

output "backend_hcl" {
  description = "Drop-in backend block for live/* stacks."
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.state.id}"
        key            = "live/<env>/terraform.tfstate"
        region         = "${var.aws_region}"
        dynamodb_table = "${aws_dynamodb_table.lock.name}"
        encrypt        = true
      }
    }
  EOT
}
