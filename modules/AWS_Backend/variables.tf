variable "s3_bucket_name" {
  type = string
}
variable "dynamodb_name" {
 type = string 
}
variable "environment" {
  type = string
  default = "dev"
}

variable "app_name" {
  type = string
}

locals {
  tags = {
    env = "${var.environment}"
    description = "This will be used for terraform backend"
    dynamodb_name = "${var.app_name}-${var.dynamodb_name}-${var.environment}"
    s3_bucket_name = "${var.app_name}-${var.s3_bucket_name}-${var.environment}"

  }
}