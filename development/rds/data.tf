data "aws_vpc" "gemtech_vpc" {
  filter {
    name   = "tag:Name"
    values = ["gemtech-vpc-prod"]
  }
}


