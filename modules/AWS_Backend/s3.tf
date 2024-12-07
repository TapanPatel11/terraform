resource "aws_s3_bucket" "s3backend" {
  bucket = local.s3_bucket_name

  object_lock_enabled = true

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "kms_key" {
  description             = "This key is used to encrypt backend bucket objects"
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config" {
  bucket = aws_s3_bucket.s3backend.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}