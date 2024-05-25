# variables.tf

variable "aws_region" {
  description = "The AWS region where VPCs are located."
  default     = "us-east-2" # Change this to your desired region
}

variable "vpc1_id" {
  description = "vpc-0c9211805be810d87"
  # Update with the actual VPC ID
}

variable "vpc2_id" {
  description = "vpc-0f7d0411193a3a5af"
  # Update with the actual VPC ID
}

variable "vpc1_route_table_id" {
  description = "rtb-09d01dcebbd62a924"
  # Update with the actual route table ID
}

variable "vpc2_route_table_id" {
  description = "rtb-02b08cd14665c9cd7"
  # Update with the actual route table ID
}

