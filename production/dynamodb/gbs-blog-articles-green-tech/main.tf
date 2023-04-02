terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/dynamodb/gbs-blog-articles-green-tech/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "Date"

  attribute {
      name = "Id"
      type = "S"
    }

  attribute {
      name = "Date"
      type = "S"
    }

  global_secondary_index {
    name = "Date-index"
    hash_key = "Date"
    range_key = "Id"
    projection_type = "ALL"
  }
}
