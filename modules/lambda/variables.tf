variable "functionName" {
    type = string
    description = "Lamda Function Name"
}
variable "runtime" {
    type = string
    description = "Lamda Function runtime environment"
}
variable "handler" {
    type = string
    description = "Lamda Function handler aka entrypoint for funtion"
}

variable "description" {
    type = string 
    description = "Lamda Function Description"
}
variable "lambdaRole" {
    type = string 
    description = "Lamda Function Description"
}
variable "albTargetGroup" {}

variable "bucketFileName" {}

variable "awsRegion" {}