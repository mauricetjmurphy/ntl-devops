terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/dynamodb/gbs-blog-keywords/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "CreatedAt"
  range_key    = "Topic"

  attribute {
    name = "Topic"
    type = "S"
  }

  attribute {
    name = "CreatedAt"
    type = "S"
  }

  global_secondary_index {
    name            = "CreatedAt-index"
    hash_key        = "CreatedAt"
    range_key       = "Topic"
    projection_type = "ALL"
  }

  tags = {
    Environment = var.environment
    Project     = "GBS Blog Website"
  }
}
