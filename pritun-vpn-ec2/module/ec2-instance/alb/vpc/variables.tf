variable "vpc-cidr" {
  type        = string
  description = "VPC ID"
}

variable "public-subnet1-cidr" {
  type    = string
  description = "public-subnet1-cidr"
}

variable "public-subnet2-cidr" {
  type    = string
  description = "public-subnet2-cidr"
}

variable "private-subnet1-cidr" {
  type    = string
  description = "private-subnet1-cidr"
}

variable "private-subnet2-cidr" {
  type    = string
  description = "private-subnet2-cidr"
}

variable "igw-name" {
  type        = string
  description = "igw-name"
}

variable "vpc_name" {
  type    = string
  description = "vpc-name"
}

variable "public-rt-name" {
  type    = string
  description = "public-rt-name"
}

variable "private-rt-name" {
  type    = string
  description = "private-rt-name"
}





