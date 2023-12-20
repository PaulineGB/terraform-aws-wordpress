variable "aws_access_key" {
    description = "AWS Access Key"
    type        = string
    sensitive   = true
}

variable "aws_secret_key" {
    description = "AWS Secret Key"
    type        = string
    sensitive   = true
}

variable "provider_region" {
    type    = string
    default = "eu-west-3"
}

variable "namespace" {
    type    = string
    default = "terraeval_pgb"
}

variable "db_username" {
    description = "Database administrator username"
    type        = string
    sensitive   = true
}

variable "db_password" {
    description = "Database administrator password"
    type        = string
    sensitive   = true
}

variable "az_a" {
    description = "Availability Zone A"
    type        = string
}

variable "az_b" {
    description = "Availability Zone B"
    type        = string
}
