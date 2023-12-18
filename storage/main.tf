resource "aws_db_instance" "aws_terraeval_dba" {
    allocated_storage    = 10
    db_name              = "terraeval_dba"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${aws_subnet.public_subnet_a.name}"
    port                 = 3306
    username             = #
    password             = #
    skip_final_snapshot  = true
    availability_zone    = var.az_a
}

resource "aws_db_instance" "aws_terraeval_dbb" {
    allocated_storage    = 10
    db_name              = "terraeval_dbb"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    db_subnet_group_name = "${aws_subnet.public_subnet_b.name}"
    port                 = 3306
    username             = #
    password             = #
    skip_final_snapshot  = true
    availability_zone    = var.az_b
}
