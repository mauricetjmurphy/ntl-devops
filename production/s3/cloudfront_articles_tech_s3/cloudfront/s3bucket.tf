
resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.main.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PolicyForCloudFrontPrivateContent",
  "Statement": [
    {
      "Sid": " Grant a CloudFront Origin Identity access to support private content",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cloudfront.id}"
      },
      "Action": "s3:GetObject",
      "Resource": "${aws_s3_bucket.main.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  tags = {
    Name = var.bucket_name
  }
}
resource "aws_s3_bucket_website_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_public_access_block" "main-public-block" {
  bucket = aws_s3_bucket.main.id

  block_public_acls   = true
  block_public_policy = true
}

