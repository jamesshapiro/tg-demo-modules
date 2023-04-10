terraform {
  # Live modules pin exact Terraform version; generic modules let consumers pin the version.
  # The latest version of Terragrunt (v0.36.0 and above) recommends Terraform 1.1.4 or above.
  required_version = "= 1.3.7"

  # Live modules pin exact provider version; generic modules let consumers pin the version.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 3.7.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SQS QUEUE instance
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = var.name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "PK1"

  attribute {
    name = "PK1"
    type = "S"
  }
}