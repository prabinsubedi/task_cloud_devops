variable "awsRegion" {
  type        = string
  description = "Aws Region"
}
variable "awsZone" {
  type    = string
  description = "Zone for the Monese Task"
}
variable "envName" {
  type        = string
  description = "Environment Name"
}

variable "vpcNetwork" {
  type    = string
  default = "192.168.0.0/16"
}



