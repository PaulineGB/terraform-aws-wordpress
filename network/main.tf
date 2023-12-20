###
# VPC
###

resource "aws_vpc" "terraeval_vpc" {
    cidr_block           = var.cidr_vpc
    enable_dns_support   = true
    enable_dns_hostnames = true
    tags = {
        Name = "terraeval-vpc"
    }
}

###
# Public subnets
###

resource "aws_subnet" "public_subnet_a" {
  	vpc_id                  = "${aws_vpc.terraeval_vpc.id}"
  	cidr_block              = var.cidr_public_subnet_a
  	map_public_ip_on_launch = "true"
  	availability_zone       = var.az_a

  	tags = {
		Name = "public-a"
  	}

  	depends_on = [aws_vpc.terraeval_vpc]
}

resource "aws_subnet" "public_subnet_b" {
	vpc_id                  = "${aws_vpc.terraeval_vpc.id}"
	cidr_block              = var.cidr_public_subnet_b
	map_public_ip_on_launch = "true"
	availability_zone       = var.az_b

	tags = {
		Name = "public-b"
	}
	depends_on = [aws_vpc.terraeval_vpc]
}

###
# Private subnets
###

resource "aws_subnet" "app_subnet_a" {
	vpc_id                  = "${aws_vpc.terraeval_vpc.id}"
	cidr_block              = var.cidr_app_subnet_a
	map_public_ip_on_launch = "true"
	availability_zone       = var.az_b

	tags = {
		Name = "app-a"
	}
	depends_on = [aws_vpc.terraeval_vpc]
}

resource "aws_subnet" "app_subnet_b" {
	vpc_id                  = "${aws_vpc.terraeval_vpc.id}"
	cidr_block              = var.cidr_app_subnet_b
	map_public_ip_on_launch = "true"
	availability_zone       = var.az_b

	tags = {
		Name = "app-b"
	}
	depends_on = [aws_vpc.terraeval_vpc]
}

###
# Internet gateway
###

resource "aws_internet_gateway" "terraeval_igateway" {
	vpc_id = "${aws_vpc.terraeval_vpc.id}"

	tags = {
		Name = "terraeval-igateway"
	}
	depends_on = [aws_vpc.terraeval_vpc]
}

###
# Route table
###

resource "aws_route_table" "rtb_public" {
	vpc_id = "${aws_vpc.terraeval_vpc.id}"
	tags = {
		Name = "terraeval-public-routetable"
	}
	depends_on = [aws_vpc.terraeval_vpc]
}

resource "aws_route" "route_igw" {
	route_table_id         = "${aws_route_table.rtb_public.id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id             = "${aws_internet_gateway.terraeval_igateway.id}"

	depends_on = [aws_internet_gateway.terraeval_igateway]
}

resource "aws_route_table_association" "rta_subnet_association_puba" {
	subnet_id      = "${aws_subnet.public_subnet_a.id}"
	route_table_id = "${aws_route_table.rtb_public.id}"

	depends_on = [aws_route_table.rtb_public]
}

resource "aws_route_table_association" "rta_subnet_association_pubb" {
	subnet_id      = "${aws_subnet.public_subnet_b.id}"
	route_table_id = "${aws_route_table.rtb_public.id}"

	depends_on = [aws_route_table.rtb_public]
}

###
# NAT gateway subnet A
###

resource "aws_eip" "eip_public_a" {
  	domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_a" {
	allocation_id = "${aws_eip.eip_public_a.id}"
	subnet_id     = "${aws_subnet.public_subnet_a.id}"

	tags = {
		Name = "terraeval-nat-public-a"
	}
}

resource "aws_route_table" "rtb_appa" {
	vpc_id = "${aws_vpc.terraeval_vpc.id}"
	tags = {
		Name = "terraeval-appa-routetable"
	}
}

resource "aws_route" "route_appa_nat" {
	route_table_id         = "${aws_route_table.rtb_appa.id}"
	destination_cidr_block = "10.0.128.0/20"
	nat_gateway_id         = "${aws_nat_gateway.gw_public_a.id}"
}

resource "aws_route_table_association" "rta_subnet_association_appa" {
	subnet_id      = "${aws_subnet.app_subnet_a.id}"
	route_table_id = "${aws_route_table.rtb_appa.id}"
}

###
# NAT gateway subnet B
###

resource "aws_eip" "eip_public_b" {
  	domain = "vpc"
}
resource "aws_nat_gateway" "gw_public_b" {
	allocation_id = "${aws_eip.eip_public_b.id}"
	subnet_id     = "${aws_subnet.public_subnet_b.id}"

	tags = {
		Name = "terraeval-nat-public-b"
	}
}

resource "aws_route_table" "rtb_appb" {
	vpc_id = "${aws_vpc.terraeval_vpc.id}"

	tags = {
		Name = "terraeval-appb-routetable"
	}
}

resource "aws_route" "route_appb_nat" {
	route_table_id         = "${aws_route_table.rtb_appb.id}"
	destination_cidr_block = "10.0.144.0/20"
	nat_gateway_id         = "${aws_nat_gateway.gw_public_b.id}"
}

resource "aws_route_table_association" "rta_subnet_association_appb" {
	subnet_id      = "${aws_subnet.app_subnet_b.id}"
	route_table_id = "${aws_route_table.rtb_appb.id}"
}
