variable "lambdaArn" {
    type = string 
    description = "Lamda Function Name"
}
variable "elbName" {
    type = string 
    description = "Load Balancer Name" 
}
variable "loadBalancerType" {
    type = string 
    description = "Load Balancer Type" 
}

variable "securityGroup" {}

variable "accessLogBucket" {
    type = string 
}

variable "environment" {
    type = string 
}

variable "vpcId" {
    description = "VPC ID"
}

variable "protocol" {
  default = "HTTP"
}
variable "port" {
  default = "80"
}

variable "publicSubnet" {}

variable "targetGroupname" {}