output "cidr_vpc" {
    value = aws_vpc.terraeval_vpc
}

output "app_subnet_a" {
    value = aws_subnet.app_subnet_a
}

output "app_subnet_b" {
    value = aws_subnet.app_subnet_b
}

output "public_subnet_a" {
    value = aws_subnet.public_subnet_a
}

output "public_subnet_b" {
    value = aws_subnet.public_subnet_b
}
