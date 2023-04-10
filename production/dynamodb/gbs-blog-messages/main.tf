terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/dynamodb/gbs-blog-messages/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Date"
  range_key      = "Email"

   attribute {
      name = "Email"
      type = "S"
    }

  attribute {
      name = "Date"
      type = "S"
    }

  global_secondary_index {
    name = "Date-index"
    hash_key = "Date"
    range_key = "Email"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Project     = "GBS Blog Website"
  }
}
