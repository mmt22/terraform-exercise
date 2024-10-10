variable "region" {
  type        = string
  description = "The AWS region"
}

variable "instance_name" {
  type        = string
  description = "Instance Name"
}

variable "instance_type" {
  type        = string
  description = "Instance Type"
}

variable "key_name" {
  type        = string
  description = "private pem file name"
}

variable "volume_type" {
  type        = string
  description = "volume_type"
}

variable "volume_size" {
  type        = number
  description = "volume_size"
}

variable "volume_encryption" {
  type        = bool
  description = "volume_encryption"
}

variable "termination-protect" {
  type        = bool
  description = "termination-protect"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet-id" {
  type    = string
}


variable "vpc_security_group_ids" {
  type    = list(string)
}


variable "iam_instance_profile" {
  type        = string
  description = "iam instance profile"
}

variable "ami" {
  type        = string
  description = "AMI of the Instance"
}

variable "userdatafile" {
  type        = string
  description = "userdatafile path"
}

variable "source_dest_check" {
  type        = bool
  description = "true or flase"
}