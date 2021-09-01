output "albTargetGroup" {
    value = aws_lb_target_group.lambda_target.arn
}
output "dns_name" {
    value = aws_lb.lambda_function_access.dns_name
}