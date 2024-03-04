import os
import json
import boto3
from textractor import Textractor
from textractor.visualizers.entitylist import EntityList
from textractor.data.constants import TextractFeatures
from textractor.data.text_linearization_config import TextLinearizationConfig


s3_client = boto3.client("s3")
lambda_client = boto3.client("lambda")
textractor = Textractor()


def lambda_handler(event, context):
    records = json.loads(event["Records"][0]["body"])["Records"]
    for record in records:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        extension = os.path.splitext(key)[-1]

        print(f"Received message: {key} with extension {extension}")

        if extension == ".pdf":
            ## call textract
            print(f"Invoking textract for {key}")
            document = textractor.start_document_analysis(
                DocumentLocation={"S3Object": {"Bucket": bucket, "Name": key}},
                FeatureTypes=[TextractFeatures.LAYOUT, TextractFeatures.TABLES],
            )

            config = TextLinearizationConfig(
                hide_figure_layout=True,
                header_prefix="#",
                title_prefix="##",
                list_layout_prefix="*",
                list_layout_suffix="*",
                section_header_prefix="###",
                add_prefixes_and_suffixes_as_words=True,
                add_prefixes_and_suffixes_in_text=True,
            )
            
            text = document.get_text(config=config)
            # write to s3
            s3_client.put_object(
                Bucket=os.environ["RAW_TEXT_STORAGE"],
                Key=f"{key}.txt",
                Body=text,
            )
            print(f"Invoked textract for {key}")