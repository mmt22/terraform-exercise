variable "ami" {
    description = "ami id"
    type = string  
}

variable "key_name" {
    description = "key_name"
    type = string  
}

variable "vpc_id" {
    description = "vpc_id"
    type = string  
}

variable "subnet_id" {
    description = "subnet_id"
    type = string  
}


variable "iam_instance_profile" {
    description = "iam_instance_profile"
    type = string  
}

variable "user_data" {
    description = "user_data"
    type = string  
}

variable "volume_size" {
    description = "volume_size"
    type = number  
}

variable "vpc_security_group_ids" {
    description = "vpc_security_group_ids"
    type = string  
}

variable "instance-name" {
    description = "instance-name"
    type = string  
}
















