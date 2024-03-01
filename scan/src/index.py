import boto3
import os
import logging
import botocore
import uuid

s3_client = boto3.client("s3")
sqs_client = boto3.client("sqs")
queue_url = os.environ["QUEUE_URL"]
source_bucket = os.environ["SOURCE_BUCKET"]

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    logger.info("Event: " + str(event))
    depth = event.get("depth", None)
    scan_s3_bucket(depth=depth, queue_url=queue_url)


def scan_s3_bucket(depth: int, queue_url: str, prefix: str = ""):
    if depth == 0:
        return

    paginator = s3_client.get_paginator("list_objects_v2")
    try:
        pages = paginator.paginate(Bucket=source_bucket, Prefix=prefix)
    except botocore.exceptions.ClientError as e:
        logger.error(f"Unable to access bucket {source_bucket}. Error: {e}")
        raise e

    message_batch = []
    for page in pages:
        for content in page.get("Contents", []):
            key = content["Key"]
            logger.info("Key: " + key)
            message_batch.append(
                {
                    "Id": str(uuid.uuid4()),  # Generate a unique ID for each message
                    "MessageBody": f's3://{source_bucket}/{key}'
                }
            )
            if len(message_batch) == 10:
                push_to_sqs(queue_url, message_batch)
                message_batch = []

        for common_prefix in page.get("CommonPrefixes", []):
            new_prefix = common_prefix["Prefix"]
            scan_s3_bucket(depth=depth - 1, queue_url=queue_url, prefix=new_prefix)

    # Send remaining messages in the batch
    if message_batch:
        push_to_sqs(queue_url, message_batch)


def push_to_sqs(queue_url, message_batch):
    logger.info("Sending message batch: " + str(message_batch))
    response = sqs_client.send_message_batch(QueueUrl=queue_url, Entries=message_batch)

    # Check if any messages failed to send
    if "Failed" in response and response["Failed"]:
        logger.error("Failed to send messages: " + str(response["Failed"]))
