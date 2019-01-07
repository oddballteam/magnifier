variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  description = "us-east-1"
}

variable "aws_resource_prefix" {
  description = "magnifier"
}

variable "S3_BACKEND_BUCKET" {
  default = "magnifier-tf"
}

variable "S3_BUCKET_REGION" {
  type    = "string"
  default = "us-east-1"
}

variable "AWS_REGION" {
  type    = "string"
  default = "us-east-1"
}

variable "TAG_ENV" {
  default = "dev"
}

variable "ENV" {
  default = "PROD"
}

variable "CIDR_PRIVATE" {
  default = "10.0.1.0/24,10.0.2.0/24"
}

variable "CIDR_PUBLIC" {
  default = "10.0.101.0/24,10.0.102.0/24"
}

variable "db_pass" {}

variable "db_user" {
  default = "magnifier"
}

variable "db_name" {
  default = "magnifier"
}

variable "container_port" {
  default = "3000"
}

variable "ecs_key_pair_name" {
  default = "rob-key-pair-useast"
}
