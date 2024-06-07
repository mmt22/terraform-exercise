variable "region" {
  type        = string
  description = "The AWS region."
  default     = "ap-south-1"
}

variable "ami" {
  type        = string
  description = "AMI of the Instance"
  default     = "ami-05e00961530ae1b55"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t3a.medium"
}

variable "key_name" {
  type        = string
  description = "private pem file name"
  default     = "website"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-0d923e7ee6f36cb17"
}

variable "subnet_id" {
  type    = list(string)
  default = ["sg-0c01ed90f6882d3bc"] # Example default security group IDs
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = ["sg-06dfa5c2367f1db33"] # Example default security group IDs
}


variable "iam_instance_profile" {
  type        = string
  description = "iam instance profile"
  default     = "SSM-ROLE-EC2"
}

