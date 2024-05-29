variable "ami-id" {
    type = string
    default = "value"  
}

variable "lt-name" {
    type = string
    default = "value"  
}

variable "instance_type" {
    type = string
    default = "value"  
}

variable "asg-name" {
    type = string
    default = "value"  
}

variable "role-name" {
    type = string
    default = "value"  
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

variable "pem-key" {
    type = string
    default = "website"  
}

variable "vpc-id" {
    type = string
    default = "vpc-0d923e7ee6f36cb17"  
}

variable "subnet-ids" {
    type = list(string)
    default = ["subnet-03636e6840a6a7933","subnet-093e8e872dc6ed5d4"]
}

variable "sg-ids" {
    type = list(string)
    default = ["sg-06dfa5c2367f1db33"]
}

variable "userdata" {
    type = string
    default = "userdatafilepath"
}

variable "lt-id" {
    type = string
    default = "value"  
}


