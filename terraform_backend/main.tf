provider "aws" {
}
module "dev-backend" {
  source = "../modules/AWS_Backend"
  app_name = "atlantis"
  environment = "dev"
  s3_bucket_name = "terraform-state"
  dynamodb_name = "terraform-state"
}