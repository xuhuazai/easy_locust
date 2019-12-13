#!/bin/bash

WORKDIR=$(dirname $0)
CONTAINER_NAME="easy_locust"

function RemoveContainer {
	docker stop $1 && docker rm $1
}

RemoveContainer $CONTAINER_NAME

docker run
    -v $WORKDIR/locustfile:/software/locust/locustfile \ 
    -e SCENARIO_FILE=/software/locust/locustfile/locustfile.py \
    -p 5557:5557 \
    -p 5558:5558 \
    -p 8089:8089 \
    --name $CONTAINER_NAME \
    easy_locust:v1