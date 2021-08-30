
variable "publicSubnet" {}

variable "subnetPublicName" {
  type    = string
  description = "Public Subnet Name"
}
variable "subnetPrivateName" {}
variable "availabilityZonePublic" {}

variable "igwId" {
  type    = string
  description = "Internet Gateway ID" 
}

variable "vpcId" {
  type    = string
  description = "Internet Gateway ID" 
}
variable "routeTableName" {
  type    = string
  description = "Internet Gateway ID" 
}
