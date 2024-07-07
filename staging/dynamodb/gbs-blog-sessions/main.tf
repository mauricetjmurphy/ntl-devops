terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-dev"
    key     = "tfstate/environments/development/dynamodb/gbs-blog-sessions/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "user"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "user"
    type = "S"
  }

  attribute {
    name = "valid"
    type = "S"
  }

  global_secondary_index {
    name            = "user-index"
    hash_key        = "user"
    range_key       = "id"
    projection_type = "ALL"
  }
}
