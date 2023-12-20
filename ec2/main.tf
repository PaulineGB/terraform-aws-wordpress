##
# Modules instanciation
###

module "network" {
    source = "../network"
    az_a = var.az_a
    az_b = var.az_b
}

module "security_rules" {
    source = "../security_rules"
    az_a = var.az_a
    az_b = var.az_b
}

###
# Data sources
###

data "aws_ami" "terraeval-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

###
# EC2 ZONE A
###

resource "aws_instance" "terraeval_a" {
    ami                    = data.aws_ami.terraeval-ami.id
    instance_type          = "t2.micro"
    subnet_id              = "${module.network.app_subnet_a.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_terraeval.id}"]
    key_name               = "${module.security_rules.key_name}"
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_a
    tags = {
        Name = "terraeval-a"
    }
}

###
# EC2 ZONE B
###

resource "aws_instance" "terraeval_b" {
    ami                    = data.aws_ami.terraeval-ami.id
    instance_type          = "t2.micro"
    subnet_id              = "${module.network.app_subnet_b.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_terraeval.id}"]
    key_name               = "${module.security_rules.key_name}"
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_b
    tags = {
        Name = "terraeval-b"
    }
}

###
# EC2 Security Group
###

resource "aws_security_group" "sg_terraeval" {
    name   = "sg_terraeval"
    vpc_id = "${module.network.cidr_vpc.id}"

    tags = {
        Name = "sg-terraeval"
    }
}

resource "aws_security_group_rule" "allow_all" {
    type              = "ingress"
    cidr_blocks       = ["10.0.128.0/20", "10.0.144.0/20"]
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    security_group_id = "${aws_security_group.sg_terraeval.id}"
}

resource "aws_security_group_rule" "outbound_allow_all" {
    type = "egress"

    cidr_blocks       = ["0.0.0.0/0"]
    to_port           = 0
    from_port         = 0
    protocol          = "-1"
    security_group_id = "${aws_security_group.sg_terraeval.id}"
}
