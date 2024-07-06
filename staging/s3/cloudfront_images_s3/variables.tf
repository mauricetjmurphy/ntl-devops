variable "environment" {
  type        = string
  description = "Must Be Lower Case! (dev, stg, prod and dr)"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "static_libs_s3_bucket_name" {
  type        = string
  description = "A S3 bucket name to hold static libraries files (js, css, image ...)"
}

variable "description" {
  type        = string
  description = "sfp Portal CloudFront description"
}