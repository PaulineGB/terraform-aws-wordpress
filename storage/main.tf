###
# Modules instanciation
###

module "network" {
    source = "../network"
    az_a = var.az_a
    az_b = var.az_b
}

###
# Storage
###

resource "aws_db_instance" "aws_terraeval_dba" {
    allocated_storage    = 10
    db_name              = "terraeval_dba"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${module.network.public_subnet_a.name}"
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}

resource "aws_db_instance" "aws_terraeval_dbb" {
    allocated_storage    = 10
    db_name              = "terraeval_dbb"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${module.network.public_subnet_b.name}"
    port                 = 3306
    skip_final_snapshot  = true
    password = var.db_password
    username = var.db_username
}
