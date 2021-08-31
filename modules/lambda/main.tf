data "archive_file" "python_lambda_zip" {  
  type        = "zip"
  output_path = "./python_lambda.zip"
	source {
    content = <<EOF
import boto3
import json
import os 
def handler(event, context):
  path = event['path']
  request = event['httpMethod']
  bucket = os.environ.get('bucket')
  region = os.environ.get('region')
  s3 = boto3.client('s3', region)
  paginator = s3.get_paginator("list_objects_v2")
  pages = paginator.paginate(Bucket=bucket)
  objectNameList = []
  objectSizeList = [] 
  dictObjectNameSize = {} 
  if path == "/lambda/get-objects" and request=="GET":
    for page in pages:
      for object in page['Contents']:
        objectNameList.append(object['Key'])
        objectSizeList.append(object['Size'])
    dictObjectNameSize = {key: value for key, value in zip(objectNameList, objectSizeList)}
    response = {
      "statusCode": 200,
      "statusDescription": "200 OK",
      "isBase64Encoded": False,
      "headers": {
      "Content-Type": "application/json; charset=utf-8"
        },
      "body": json.dumps(dictObjectNameSize, default=str)
      }
    return response
EOF
    filename = "function.py"
  }
}

resource "aws_lambda_function" "monese_task_function" {      
  filename      = data.archive_file.python_lambda_zip.output_path
  function_name = var.functionName
  role          = var.lambdaRole
  handler       = var.handler
  runtime = var.runtime 
  description = var.description 
  source_code_hash = data.archive_file.python_lambda_zip.output_base64sha256 #created before terraform apply see scripts folder
  publish  = true
  environment {
    variables = {
      bucket =  "${var.bucketFileName}"
      region = "${var.awsRegion}"
    }
  }
}
resource "aws_cloudwatch_log_group" "lamda_loggroup" {
  name              = "/aws/lambda/${aws_lambda_function.monese_task_function.function_name}"
  retention_in_days = 1
}
resource "aws_lambda_permission" "allow_lb_invoke_lambda" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.monese_task_function.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = var.albTargetGroup 
}