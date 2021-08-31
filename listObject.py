
import boto3
import json
import os 
# bucket = os.environ.get('BUCKET')
s3 = boto3.client('s3')
paginator = s3.get_paginator("list_objects_v2")
pages = paginator.paginate(Bucket="monese-task-eu-central-1-bucket-files")
objectList = []
sizeList = []
for page in pages:
    for page in pages:
        for object in page['Contents']:
            objectList.append(object['Key'])
            sizeList.append(object['Size'])
finalDIct = {key: value for key, value in zip(objectList, sizeList)}
response = {
    "statusCode": 200,
    "statusDescription": "200 OK",
    "isBase64Encoded": False,
    "headers": {
    "Content-Type": "application/json; charset=utf-8"
        },
    "body": json.dumps(finalDIct, default=str)
}
    
print(response)