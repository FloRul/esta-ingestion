aws_region = "us-east-1"
project_name = "esta"

## source_storage
bucket_name = "ingestion-source-storage"
ingestion_queue_name = "ingestion-source-ingestion"
notification_filter_prefix = ".pdf"

## parsing_dispatcher
pdf_parsing_lambda_name = "ingestion-pdf-parsing"
