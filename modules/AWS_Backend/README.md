# AWS Terraform Backend Module

!!!abstract "What's this?"
    This module simplifies the creation and management of an S3 backend for storing Terraform state files. It also includes DynamoDB table setup for state locking, ensuring safe and reliable operations in team environments.

## Features

???+Example "Why use this?"
    - [x] Creation of an S3 bucket with object locking enabled for state file storage.
    - [x] Integration with DynamoDB for Terraform state locking.
    - [x] Server-side encryption using KMS for added security.
    - [x] Automatic versioning of state files.
    - [x] Parameterized configuration for customization.

---

## Requirements

???+warning "Pre-requisites"
    - [x] **Terraform version:** >= 1.6.1
    - [x] **AWS Provider:** >= 5.8.0
    - [x] AWS IAM permissions to create S3, DynamoDB, and KMS resources.

---

## Inputs

??? "Backend Configuration"
    | Name            | Description                                      | Type   | Default  |
    |-----------------|--------------------------------------------------|--------|----------|
    | `s3_bucket_name`| Name of the S3 bucket for storing Terraform state.| string | N/A      |
    | `dynamodb_name` | Name of the DynamoDB table for state locking.    | string | N/A      |
    | `environment`   | Deployment environment (e.g., dev, prod).        | string | `dev`    |
    | `app_name`      | Name of the application.                         | string | N/A      |

---

## Outputs

??? "Outputs"
    | Name                          | Description                                          |
    |-------------------------------|------------------------------------------------------|
    | `s3_bucket_id`                | ID of the created S3 bucket.                        |
    | `dynamodb_table_name`         | Name of the DynamoDB table used for state locking.  |
    | `kms_key_arn`                 | ARN of the KMS key used for encryption.             |
    | `s3_bucket_arn`               | ARN of the S3 bucket.                               |

---

## Usage

```hcl
module "terraform_backend" {
  source = "./path-to-this-module"

  app_name        = "my-app"
  s3_bucket_name  = "state-bucket"
  dynamodb_name   = "state-lock"
  environment     = "production"
}
```

---

## Resources Created
- S3 bucket with object locking and versioning enabled.
- DynamoDB table for state locking with a primary key (`LockID`).
- KMS key for server-side encryption of the S3 bucket.

---

## **Contact**

!!!question "Any doubts?"
    Feel free to reach out if you have any suggestions, doubts, or wish to know more! Thanks!

---
