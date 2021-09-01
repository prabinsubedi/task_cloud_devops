locals {
  envRegion = "${var.envName}-${var.awsRegion}"
  env       = var.envName
}

module "vpc" {
  source            = "./modules/vpc"
  cidr              = var.vpcNetwork
  vpcName           = "${local.envRegion}-vpc"
  securityGroupName = "${local.env}-sg"
}

module "network" {
  source                 = "./modules/network"
  publicSubnet           = ["192.168.1.0/24", "192.168.2.0/24"]
  availabilityZonePublic = ["eu-central-1a", "eu-central-1b"]
  igwId                  = module.igw.igw_id
  vpcId                  = module.vpc.vpc_id
  subnetPublicName       = "${local.env}-public-subnet"
  routeTableName         = "${local.env}-route-table"
}


module "igw" {
  source  = "./modules/igw"
  igwName = "${local.env}-${var.awsRegion}-Internet-Gateway"
  vpcId   = module.vpc.vpc_id
}

module "s3" {
  source               = "./modules/s3"
  bucketName           = "${local.env}-${var.awsRegion}-bucket"
  acl                  = "private"
  elbLogExpirationDays = "1"
  versioning = {
    enabled = true
  }
}

module "iam" {
  source            = "./modules/iam"
  lambdaIamRoleName = "${local.env}-lambda-role"
  policyName        = "${local.env}-bucket-policy"
  bucketFileName    = module.s3.bucket_files
  bucketElbName     = module.s3.bucket_elb_logs
}

module "lambda" {
  source         = "./modules/lambda"
  lambdaRole     = module.iam.lambda_role
  functionName   = "${local.env}-lambda-function"
  runtime        = "python3.8"
  description    = "Python hello world lambda."
  handler        = "function.handler"
  albTargetGroup = module.elb.albTargetGroup
  bucketFileName = module.s3.bucket_files
  awsRegion      = var.awsRegion
}

module "elb" {
  source           = "./modules/elb"
  elbName          = "${local.env}-lambda-loadbalancer"
  loadBalancerType = "application"
  publicSubnet     = module.network.publicSubnet
  securityGroup    = module.vpc.securityGroupName
  accessLogBucket  = module.s3.bucket_elb_logs
  environment      = local.env
  targetGroupname  = "${local.env}-lambda-target"
  vpcId            = module.vpc.vpc_id
  lambdaArn        = module.lambda.lambda_function_name
}