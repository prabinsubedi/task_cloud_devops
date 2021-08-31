# Script to Generate 1024 files in S3 Bucket 
import random
import os 
dirname = os.path.dirname(__file__)
filesNumber = 1024
fileContent = []
for n in range(filesNumber):
    filename = os.path.join(dirname, 'modules/s3/filesListS3Upload/') + "moneseTestFile" + str(n) + ".txt"
    newFile = open(filename, 'w')
    fileContent.append(filename)
    for val in range(len(fileContent)):
        newFile.write(str(fileContent[val]) + "\n")
    newFile.close()
