# Creates the remote-state backend for AWS-hosted stacks (EKS, etc.).
# This stack itself uses LOCAL state — commit bootstrap/aws/terraform.tfstate
# to a secure location, or run it once and store the output elsewhere.

resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name

  tags = {
    Name      = var.state_bucket_name
    ManagedBy = "terraform"
    Purpose   = "terraform-remote-state"
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "state" {
  bucket                  = aws_s3_bucket.state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# State locking. (Note: TF 1.10+ also supports native S3 lockfiles, which can
# replace this table — kept here for broad version compatibility.)
resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    ManagedBy = "terraform"
    Purpose   = "terraform-state-lock"
  }
}
