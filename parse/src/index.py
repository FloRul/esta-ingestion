import boto3
import json
import os
from urllib.parse import unquote_plus

s3_client = boto3.client("s3")
accepted_file_extensions = [".pdf", ".txt"]

def lambda_handler(event, context):
    for record in event["Records"]:
        object_url = json.loads(record["body"])
        
        key = unquote_plus(body["Records"][0]["s3"]["object"]["key"])
        file_extension = os.path.splitext(key)[1]

        s3_client.download_file(bucket, key, "/tmp/{}".format(key))

        if file_extension == ".txt":
            # Process text file
            pass
        elif file_extension == ".jpg":
            # Process jpg file
            pass
        # Add more conditions here for other file extensions

    return {"statusCode": 200, "body": json.dumps("Files processed")}
