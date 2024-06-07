variable "vpc_id" {
  type        = string
  description = "VPC ID"
  default     = "vpc-0d923e7ee6f36cb17"
}


variable "sg-name" {
  type        = string
  description = "SG-Name"
}

variable "allow-ips" {
  type        = list(string)
  description = "VPC ID"
  default     = ["0.0.0.0/0","54.83.19.241/32"]
}

