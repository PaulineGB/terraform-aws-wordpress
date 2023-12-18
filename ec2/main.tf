###
# EC2 ZONE A
###

resource "aws_instance" "terraeval_a" {
    ami                    = data.aws_ami.terraeval-ami.id
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.app_subnet_a.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_terraeval.id}"]
    key_name               = "${aws_key_pair.myec2key.key_name}"
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
    subnet_id              = "${aws_subnet.app_subnet_b.id}"
    vpc_security_group_ids = ["${aws_security_group.sg_terraeval.id}"]
    key_name               = "${aws_key_pair.myec2key.key_name}"
    user_data              = "${file("install_wordpress.sh")}"
    availability_zone      = var.az_b
    tags = {
        Name = "terraeval-b"
    }
}