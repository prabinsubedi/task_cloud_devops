output "elastic_ip_nat" {
    value = aws_eip.nat.id
}

# output "elastic_ip_nat_two" {
#     value = aws_eip.nat.1.id
# }