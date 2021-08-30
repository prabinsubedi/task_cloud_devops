output "vpc_id" {
    value = aws_vpc.monese_task_main.id
}

output "securityGroupName" {
    value = aws_security_group.allow_inbound_http.id
}