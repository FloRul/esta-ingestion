import os
import json
import boto3

s3_client = boto3.client("s3")
lambda_client = boto3.client("lambda")


def lambda_handler(event, context):
    for record in event["Records"]:
        object_url = json.loads(record["body"])
        extension = os.path.splitext(object_url)[-1]

        # Get the mapping from environment variable
        lambda_mapping = json.loads(os.environ.get("LAMBDA_MAPPING", "{}"))

        if extension in lambda_mapping:
            lambda_to_invoke = lambda_mapping[extension]

            lambda_client.invoke(
                FunctionName=lambda_to_invoke,
                InvocationType="Event",
                Payload=json.dumps({"object_url": object_url}),
            )

            print(f"Invoked {lambda_to_invoke} for {object_url}")
