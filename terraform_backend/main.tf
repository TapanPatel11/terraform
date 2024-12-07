provider "aws" {
region = "us-east-1"
}
module "dev-backend" {
  source = "../modules/AWS_Backend"
  s3_bucket_name = "terraform-state"
  dynamodb_name = "terraform-state"
}