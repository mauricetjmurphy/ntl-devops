#lambda/variables.tf
variable "function_name" {
  type = string
}

variable "role" {
  type = string
}

variable "handler" {
  type = string
}

variable "runtime" {
type = string
}

variable "zip_file" {
type = string
}

variable "region" {
type = string
default = "us-east-1"
}

variable "accountId" {
type = string
}

variable "http_method" {
  type = string
}

variable "path" {
  type = string
}

variable "rest_api" {
  type = string
}