variable "ami-id" {
    type = string
    default = "value"  
}

variable "lt-id" {
    type = string
    default = ""
}


variable "termination_policies" {
    type = list(string)
    default = [""] 
}

variable "asg-name" {
    type = string
    default = ""
}

variable "desired-cap" {
    type = number
    default = 1 
}

variable "min-cap" {
    type = number
    default = 1
}
variable "max-cap" {
    type = number
    default = 2
}

variable "asg-azs" {
    type = list(string)
    default = [ "ap-south-1a","ap-south-1b","ap-south-1c" ]
  
}

variable "target-grp-arn" {
    type = list(string)
    default = ["value"]
}

