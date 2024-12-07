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

locals {
  tags = {
    env = "${var.environment}"
    description = "This will be used for terraform backend"
  }
}