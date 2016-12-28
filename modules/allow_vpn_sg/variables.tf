// Module specific variables
variable "name" {
  default = "test"
}

variable "environment" {
  default = "test"
}


variable "vpc_id" {
  description = "The VPC this security group will go in"
}

variable "source_cidr_block" {
  description = "The source CIDR block to allow traffic from"
  default = ["52.6.127.27/32","52.15.106.207/32","52.19.174.96/32","52.27.200.148/32","52.52.115.152/32"]
}