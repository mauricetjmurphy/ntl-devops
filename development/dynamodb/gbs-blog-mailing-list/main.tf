terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-dev"
    key     = "tfstate/environments/development/dynamodb/gbs-blog-mailing-list/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "Email"

  attribute {
      name = "Id"
      type = "S"
    }

   attribute {
      name = "Email"
      type = "S"
    }
}
