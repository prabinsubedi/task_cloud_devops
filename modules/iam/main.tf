resource "aws_iam_role" "lambda_role" {  ### Lambda Role
  name = var.lambdaIamRoleName

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "bucket_access_policy" {
 name = var.policyName

 policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AccessObject",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucketFileName}",
        "arn:aws:s3:::${var.bucketFileName}/*"

      ]
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_role_policy" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "bucket_access_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.bucket_access_policy.arn
}

resource "aws_iam_role_policy" "lambda_exec_policy" {
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.lambda_role_policy.json
}
