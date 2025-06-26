
import azure.functions as func
from shared.config import get_cosmos_client, get_blob_client
from shared.models import BillingRecord

def main(req: func.HttpRequest) -> func.HttpResponse:
    record_id = req.route_params.get('record_id')
    cosmos_client = get_cosmos_client()
    record = cosmos_client.get_record(record_id)

    if record:
        return func.HttpResponse(record.json(), status_code=200)
    else:
        blob_client = get_blob_client()
        record = blob_client.get_record(record_id)
        if record:
            return func.HttpResponse(record.json(), status_code=200)
        else:
            return func.HttpResponse("Record not found.", status_code=404)
