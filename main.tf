terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.provider_region
    access_key = "AKIAR22IPVNIQCIWZM2M"
    secret_key = "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"
}

module "network" {
    source = "./network"
    namespace = var.namespace
}

module "storage" {
    source = "./storage"
    namespace = var.namespace
}

module "security" {
    source = "./security"
    namespace = var.namespace
}

module "ec2" {
    source = "./ec2"
    namespace = var.namespace
}
