variable "vpcid" {
  type        = string
  description = "VPC ID"
}

variable "subnetid" {
  type        = list(string)
  description = "subnetid"
}

variable "alb-name" {
  type    = string
  description = "alb_sg_ids"
}

variable "alb-tg-name" {
  type    = string
  description = "alb_sg_ids"
}

variable "alb-sg-name" {
  type    = string
  description = "alb_sg_ids"
}

