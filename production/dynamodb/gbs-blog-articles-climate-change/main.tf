terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/dynamodb/gbs-blog-articles-climate-change/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

resource "aws_dynamodb_table" "main" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "Id"
  range_key      = "Title"

  attribute {
      name = "Id"
      type = "S"
    }

   attribute {
      name = "Author"
      type = "S"
    }

  attribute {
      name = "Title"
      type = "S"
    }

  attribute {
      name = "Category"
      type = "S"
    }

  attribute {
      name = "Date"
      type = "S"
    }

  attribute {
      name = "Image_url"
      type = "S"
    }

   attribute {
      name = "Body"
      type = "S"
    }

  global_secondary_index {
    name = "Author-index"
    hash_key = "Author"
    range_key = "Title"
    projection_type = "ALL"
  }

  global_secondary_index {
    name = "Body-index"
    hash_key = "Body"
    range_key = "Title"
    projection_type = "ALL"
  }

  global_secondary_index {
    name = "Date-index"
    hash_key = "Date"
    range_key = "Title"
    projection_type = "ALL"
  }

  global_secondary_index {
    name = "Category-index"
    hash_key = "Category"
    range_key = "Title"
    projection_type = "ALL"
  }

  global_secondary_index {
    name = "Image_url-index"
    hash_key = "Image_url"
     range_key = "Title"
    projection_type = "ALL"
  }
}
