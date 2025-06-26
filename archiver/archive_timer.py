
import datetime
import azure.functions as func
from shared.config import get_cosmos_client, get_blob_client

def main(mytimer: func.TimerRequest) -> None:
    cosmos_client = get_cosmos_client()
    blob_client = get_blob_client()

    old_records = cosmos_client.get_records_older_than(days=90)
    for record in old_records:
        blob_client.upload_record(record)
        cosmos_client.delete_record(record.id)
