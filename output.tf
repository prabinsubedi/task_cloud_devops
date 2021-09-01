output "bucket_monese_file" {
    value = module.s3.bucket_files
}

output "bucket_monese_elb_logs" {
    value = module.s3.bucket_elb_logs
}

output "vpc_id" {
    value = module.vpc.vpc_id
}
output "igw_id" {
    value = module.igw.igw_id
}
output "lambda_role" {
    value = module.iam.lambda_role
}
output "lambda_function_name" {
    value = module.lambda.lambda_function_name
}

output "securityGroupName" {
    value = module.vpc.securityGroupName
}

output "publicSubnet" {
    value = module.network.publicSubnet
}

output "albTargetGroup" {
    value = module.elb.albTargetGroup
}
output "dns_name" {
    value = module.elb.dns_name
}