terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-dev"
    key     = "tfstate/environments/development/dynamodb/gbs-blog-articles/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "CreatedAt"

  attribute {
      name = "Id"
      type = "S"
    }

  attribute {
      name = "CreatedAt"
      type = "S"
    }

  global_secondary_index {
    name = "CreatedAt-index"
    hash_key = "CreatedAt"
    range_key = "Id"
    projection_type = "ALL"
  }   
}




