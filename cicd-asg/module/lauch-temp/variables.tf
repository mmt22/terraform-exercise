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


variable "role-name" {
    type = string
    default = "value"  
}


variable "pem-key" {
    type = string
    default = "website"  
}

variable "vpc-id" {
    type = string
    default = "vpc-0d923e7ee6f36cb17"  
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

variable "vol-size" {
    type = number
    default = 8 
}


