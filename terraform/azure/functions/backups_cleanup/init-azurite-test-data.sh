
ST_PROTOCOL=http
ST_NAME=devstoreaccount1
ST_KEY='Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw=='
ST_BLOB="$ST_PROTOCOL://127.0.0.1:10000/$ST_NAME"
ST_QUEUE="$ST_PROTOCOL://127.0.0.1:10001/$ST_NAME"
ST_TABLE="$ST_PROTOCOL://127.0.0.1:10002/$ST_NAME"
ST_CONN_STRING="DefaultEndpointsProtocol=$ST_PROTOCOL;AccountName=$ST_NAME;AccountKey=$ST_KEY;BlobEndpoint=$ST_BLOB;QueueEndpoint=$ST_QUEUE;TableEndpoint=$ST_TABLE;"

ENV=dev
ST_CONTAINERS=(
    "$ENV-core-apps-backups"
    "$ENV-home-assistant-backups"
    "$ENV-opnsense-backups"
    "$ENV-terraform-backups"
)

echo "Connection string: $ST_CONN_STRING"

for container in "${ST_CONTAINERS[@]}"; do
    echo "Creating container: $container"
    az storage container create --name "$container" --connection-string "$ST_CONN_STRING"
done


TIMESTAMPS=(
    '2020-03-03_100020'
    '2020-03-04_101020'
    '2020-03-04_100020'
    '2022-10-01_100020'
    '2022-12-09_101020'
    '2022-04-06_100020'
    '2025-05-22_100020'
    '2025-05-21_100020'
    '2025-05-20_100020'
)
BLOB_NAMES=(
    'actual-budget-data'
    'authentik-data'
    'homarr-data'
    'pihole-data'
)

for name in "${BLOB_NAMES[@]}"; do
    for timestamp in "${TIMESTAMPS[@]}"; do
        blob_name="${name}_$timestamp.tar.gz"
        echo "Creating blob: $blob_name"
        az storage blob upload --data 'test' --name "$blob_name" --container "${ST_CONTAINERS[0]}" --connection-string "$ST_CONN_STRING"
    done
done
