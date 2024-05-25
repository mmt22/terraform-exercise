# variables.tf

variable "aws_region" {
  description = "The AWS region where resources will be created."
  default     = "us-east-2" # Change this to your desired region
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "15.0.0.0/16" # Change this to your desired VPC CIDR block
}

variable "public_subnet_cidr_blocks" {
  description = "The CIDR blocks for public subnets."
  default     = ["15.0.1.0/24", "15.0.2.0/24"] # Change these to your desired public subnet CIDR blocks
}

variable "private_subnet_cidr_blocks" {
  description = "The CIDR blocks for private subnets."
  default     = ["15.0.3.0/24", "15.0.4.0/24"] # Change these to your desired private subnet CIDR blocks
}

variable "private_route_table_name" {
  description = "The name for the private route table."
  default     = "PrivateRouteTable"
}

variable "public_route_table_name" {
  description = "The name for the private route table."
  default     = "PublicRouteTable"
}


