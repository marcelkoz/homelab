import logging
import os
import azure.functions as func

from collections import defaultdict
from datetime import datetime
from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient

class InvalidFileName(Exception):
    pass

class CoreAppsFile:
    def __init__(self, file_name: str):
        error_message = f'file name "{file_name}" does not fit the core apps format'

        chunks = file_name.split('_')
        if len(chunks) != 3:
            raise InvalidFileName(error_message)

        date = chunks[1]
        time = chunks[2].split('.')[0]

        self.name = file_name
        self.service = chunks[0]
        try:
            self.timestamp = datetime.strptime(f'{date}_{time}', "%Y-%m-%d_%H%M%S")
        except ValueError:
            raise InvalidFileName(error_message)

    def __lt__(self, file):
        return self.timestamp < file.timestamp

app = func.FunctionApp()

def get_blob_client(development):
    storage_url = None
    cred = None
    if development:
        storage_url = 'http://127.0.0.1:10000/devstoreaccount1'
        cred = 'Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=='
    else:
        backups_storage_account_name = os.getenv('BACKUP_STORAGE_ACCOUNT_NAME')
        storage_url = f'https://{backups_storage_account_name}.blob.core.windows.net'
        cred = DefaultAzureCredential()

    return (BlobServiceClient(storage_url, credential=cred), storage_url)

# run 3am on saturday
@app.timer_trigger(schedule="0 0 3 * * 5", arg_name="timer", run_on_startup=False, use_monitor=False) 
def backups_cleanup(timer: func.TimerRequest) -> None:
    account_client, url = get_blob_client(development=True)
    container_client = account_client.get_container_client('dev-core-apps-backups')

    # group files into services
    services = defaultdict(list)
    for blob in container_client.list_blobs():
        try:
            file = CoreAppsFile(blob.name)
            services[file.service].append(file)
        except InvalidFileName:
            logging.info(f'skipping blob with invalid file name format: {blob.name}')

    # sort files by timestamp in descending order
    for service in services:
        services[service] = sorted(services[service], reverse=True)

    # delete files beyond the threshold below
    file_threshold = 8
    for service in services:
        if not len(services[service]) > file_threshold:
            logging.info(f'skipping service {service} which has files within the limit (threshold: {file_threshold})')
            continue

        logging.info(f'found service {service} with too many files (threshold: {file_threshold})')
        for file in services[service][file_threshold:]:
            logging.info(f'deleting blob: {file.name}')
            container_client.delete_blob(file.name)
