
resource "aws_s3_bucket" "bucket_files" {
  bucket = "${var.bucketName}-files"
  acl    = var.acl
  force_destroy = true
  
  lifecycle_rule {
    id                                     = "cleanup"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    prefix                                 = ""
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "versioning"  {
      for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]
      content {
          enabled = lookup(versioning.value, "enabled", null)
      }
  }
}
resource "aws_s3_bucket" "bucket_elb_logs" {
  bucket = "${var.bucketName}-elb-logs"
  acl    = var.acl
  force_destroy = true
  lifecycle_rule {
    id                                     = "cleanup"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 1
    prefix                                 = ""

    expiration {
      days = "${var.elbLogExpirationDays}"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  
  dynamic "versioning"  {
      for_each = length(keys(var.versioning)) == 0 ? [] : [var.versioning]
      content {
          enabled = lookup(versioning.value, "enabled", null)
      }
  }
}
data "aws_elb_service_account" "main" {}

# Creating policy on S3, for lb to write
resource "aws_s3_bucket_policy" "bucket-policy-lb" {
  bucket = aws_s3_bucket.bucket_elb_logs.id

  policy = <<POLICY
{
  "Id": "loadBalancerBucketPolicy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "testStmt1561031516716",
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.bucket_elb_logs.arn}/*",
      "Principal": {
        "AWS": [
           "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}

# generate the 1001 files 
resource "null_resource" "create_files" {
  provisioner "local-exec" {
    command = "python3 fileGenerate.py"
  }
  depends_on = [
    aws_s3_bucket.bucket_files
  ]
}
resource "null_resource" "upload_files" {
  provisioner "local-exec" {
    command = "aws s3 sync ${path.module}/filesListS3Upload s3://${aws_s3_bucket.bucket_files.id}"
  }
  depends_on = [
    null_resource.create_files
  ]
}

resource "null_resource" "remove_files" {
  provisioner "local-exec" {
    command = "rm ${path.module}/filesListS3Upload/*.txt"
  }
  depends_on = [
    aws_s3_bucket.bucket_files,
    null_resource.create_files,
    null_resource.upload_files
  ]
}


# resource "aws_s3_bucket_object" "object_upload" {
#   for_each = fileset("${path.module}/filesListS3Upload/", "*")
#   bucket = aws_s3_bucket.bucket_files.id
#   key = each.value
#   source = "${path.module}/filesListS3Upload/${each.value}"
#   etag = filemd5("${path.module}/filesListS3Upload/${each.value}")
# }