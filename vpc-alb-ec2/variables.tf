variable "region" {
  type        = string
  description = "The AWS region."
  default     = "ap-south-1"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "private pem file name"
  default     = "website"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = ""
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = [""] # Example default security group IDs
}


variable "iam_instance_profile" {
  type        = string
  description = "iam instance profile"
  default     = "SSM-ROLE-EC2"
}

variable "ami" {
  type        = string
  description = "AMI of the Instance"
  default     = "ami-0f58b397bc5c1f2e8"
}

variable "db-username" {
  type        = string
  description = "db-username"
  default     = "wpdbadmin"
}

variable "db-password" {
  type        = string
  description = "db-password"
  default     = "0f58b397bc5c1f2e8"
}







