###
# Bastion host
###

resource "aws_key_pair" "terraeval_key" {
	key_name   = "terraeval-key"
	public_key = file(var.public_key_path)
}

data "aws_ami" "terraeval-ami" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name    = "name"
        values  = ["amzn2-ami-hvm-*"]
    }
}

resource "aws_instance" "terraeval_bastion" {
    ami                    = data.aws_ami.terraeval-ami.id
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.public_subnet_a.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_22.id}"]
    key_name               = "${aws_key_pair.myec2key.key_name}"

    tags = {
        Name = "terraeval-bastion"
    }
}

###
# Security Group
###

resource "aws_security_group" "sg_22" {

    name   = "sg_22"
    vpc_id = "${aws_vpc.terraeval_vpc.id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["10.0.128.0/20", "10.0.144.0/20"]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name        = "sg-22"
    }
}

###
# NACL
###

resource "aws_network_acl" "terraeval_public_a" {
    vpc_id = "${aws_vpc.terraeval_vpc.id}"

    subnet_ids = ["${aws_subnet.public_subnet_a.id}"]

    tags = {
        Name = "acl-terraeval-public-a"
    }
}

resource "aws_network_acl_rule" "nat_inbounda" {
    network_acl_id = "${aws_network_acl.terraeval_public_a.id}"
    rule_number    = 200
    egress         = false
    protocol       = "-1"
    rule_action    = "allow"
    cidr_block = "10.0.128.0/20"
    from_port  = 0
    to_port    = 0
}

resource "aws_network_acl" "terraeval_public_b" {
    vpc_id = "${aws_vpc.terraeval_vpc.id}"

    subnet_ids = ["${aws_subnet.public_subnet_b.id}"]

    tags = {
        Name = "acl-terraeval-public-b"
    }
}

resource "aws_network_acl_rule" "nat_inboundb" {
    network_acl_id = "${aws_network_acl.terraeval_public_b.id}"
    rule_number    = 200
    egress         = true
    protocol       = "-1"
    rule_action    = "allow"
    cidr_block = "10.0.144.0/20"
    from_port  = 0
    to_port    = 0
}

###
# EC2 Security Group
###

resource "aws_security_group" "sg_terraeval" {
    name   = "sg_terraeval"
    vpc_id = "${aws_vpc.terraeval_vpc.id}"

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

###
# Load Balancer Security Group
###

resource "aws_security_group" "sg_application_lb" {

    name   = "sg_application_lb"
    vpc_id = "${aws_vpc.terraeval_vpc.id}"

    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"
        cidr_blocks = ["10.0.128.0/20", "10.0.144.0/20"]
    }

    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraeval-alb"
    }

}
