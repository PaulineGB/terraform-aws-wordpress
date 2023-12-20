variable "cidr_vpc" {
    description = "CIDR"
    default     = "10.0.0.0/16"
}

variable "cidr_public_subnet_a" {
    description = "Public subnet CIDR a"
    default     = "10.0.128.0/20"
}

variable "cidr_public_subnet_b" {
    description = "Public subnet CIDR b"
    default     = "10.0.144.0/20"
}

variable "cidr_app_subnet_a" {
    description = "Private subnet CIDR a"
    default     = "10.0.0.0/19"
}

variable "cidr_app_subnet_b" {
    description = "Private subnet CIDR b"
    default     = "10.0.32.0/19"
}

variable "az_a" {
    type        = string
}

variable "az_b" {
    type        = string
}
