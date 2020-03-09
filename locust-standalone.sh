#!/bin/bash

WORKDIR=$(cd "$(dirname "$0")";pwd)
CONTAINER_NAME="easy_locust"

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME

docker run \
    -v $WORKDIR/locustfile:/software/locust/locustfile \
    -v $WORKDIR/fix_geventhttpclient_upload_py/useragent.py:/usr/local/lib/python3.6/dist-packages/geventhttpclient/useragent.py \
    -v $WORKDIR/fix_geventhttpclient_upload_py/fasthttp.py:/usr/local/lib/python3.6/dist-packages/locust/contrib/fasthttp.py \
    -e LOCUST_MODE=standalone \
    -e SCENARIO_FILE=/software/locust/locustfile/locustfile.py \
    -p 5557:5557 \
    -p 5558:5558 \
    -p 8089:8089 \
    --name $CONTAINER_NAME \
    easy_locust:v1
