variable "cidr" {
    type = string 
    description = "VPC Subnet"
}
variable "vpcName" {
    description = "VPC Name"
}

variable "sg_ingress" {
    type = list(object({
        from_port = number
        to_port = number
        protocol = string 
        description = string 
        cidr_blocks = list(string)
        
    }))
    default = [{
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
        from_port = 80
        to_port = 80
        description = "Allow http inbound traffic"
    
    }]
}

variable "sg_egress" {
    type = list(object({
        from_port = number
        to_port = number
        protocol = string
        cidr_blocks = list(string)
    }))

    default = [{
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }]
}

variable "securityGroupName" {
    description = "Security Group Name"
}