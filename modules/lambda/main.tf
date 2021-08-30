data "archive_file" "python_lambda_zip" {  
  type        = "zip"
  output_path = "./python_lambda.zip"
	source {
    content = <<EOF
import json

def handler(event, context):

  response = {
    "statusCode": 200,
    "headers": {
      "Content-Type": "text/plain;"
    },
    "isBase64Encoded": False
  }

  if event['path'] == '/whatismyip':
    sourceip_list = event['headers']['x-forwarded-for'].split(',')
    if sourceip_list:
      sourceip = str(sourceip_list[0])
      response['body']=sourceip
    else:
      response['body']='?.?.?.?'
    return response

  response['body'] = json.dumps(event, indent=2)
  
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