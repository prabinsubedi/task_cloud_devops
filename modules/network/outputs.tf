output "publicSubnet" {
    value = aws_subnet.public_subnet.*.id
}
