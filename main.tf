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
    access_key = ""
    secret_key = ""
}

module "network" {
    source = "./network"
}

module "storage" {
    source = "./storage"
}

module "security" {
    source = "./security"
}

module "ec2" {
    source = "./ec2"
}
