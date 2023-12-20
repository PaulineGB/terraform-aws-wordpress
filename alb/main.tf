###
# Modules initialization
###

module "ec2" {
	source = "../ec2"
	az_a = var.az_a
	az_b = var.az_b
}

module "network" {
    source = "../network"
    az_a = var.az_a
    az_b = var.az_b
}

###
# Load balancer
###

resource "aws_lb" "lb_terraeval" {
	name               = "terraeval-alb"
	internal           = false
	load_balancer_type = "application"
	subnets            = ["${module.network.public_subnet_a.id}", "${module.network.public_subnet_b.id}"]
	security_groups    = ["${aws_security_group.sg_application_lb.id}"]

	enable_deletion_protection = false
}

resource "aws_lb_listener" "front_end" {
	load_balancer_arn = "${aws_lb.lb_terraeval.arn}"
	port              = "80"
	protocol          = "HTTP"

	default_action {
		type             = "forward"
		target_group_arn = "${aws_lb_target_group.terraeval_vms.arn}"
	}
}

resource "aws_lb_target_group" "terraeval_vms" {
	name     = "tf-terraeval-lb-tg"
	port     = 80
	protocol = "HTTP"
	vpc_id   = "${aws_vpc.terraeval_vpc.id}"
}

resource "aws_lb_target_group_attachment" "terraevala_tg_attachment" {
	target_group_arn = "${aws_lb_target_group.terraeval_vms.arn}"
	target_id = "${module.ec2.terraeval_a.id}"
	port = 80
}

resource "aws_lb_target_group_attachment" "terraevalb_tg_attachment" {
	target_group_arn = "${aws_lb_target_group.terraeval_vms.arn}"
	target_id = "${module.ec2.terraeval_b.id}"
	port = 80
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
