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
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

module "network" {
    source = "./network"
    az_a   = var.az_a
    az_b   = var.az_b
}

module "storage" {
    source = "./storage"
    db_password = var.db_password
    db_username = var.db_username
    az_a   = var.az_a
    az_b   = var.az_b
}

module "security" {
    source = "./security_rules"
    az_a   = var.az_a
    az_b   = var.az_b
}

module "ec2" {
    source = "./ec2"
    az_a   = var.az_a
    az_b   = var.az_b
}
