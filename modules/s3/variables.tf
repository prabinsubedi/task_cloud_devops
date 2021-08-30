variable "bucketName" {
    type = string 
    description = "Bucket Name"
}

variable "acl" {
  description = "Bucket ACL"
  type        = string
  default     = "private"
}

variable "versioning" {}

variable "elbLogExpirationDays" {}
