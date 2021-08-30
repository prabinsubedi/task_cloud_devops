variable "lambdaIamRoleName" {
    type = string 
    description = "lamda Role Name"
}

variable "bucketFileName" {
    type = string 
    description = "Bucket files Storage Name"
}

variable "policyName" {
    type = string 
    description = "Bucket Policy Name"
}

variable "bucketElbName" {
    type = string 
    description = "Bucket ELB access logs" 
}