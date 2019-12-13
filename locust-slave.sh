#!/bin/bash

WORKDIR=$(dirname $0)
CONTAINER_NAME="easy_locust_slave"

function RemoveContainer {
	docker stop $1 && docker rm $1
}

RemoveContainer $(docker ps -a | awk '/{$CONTAINER_NAME}/ {print $1}')

#设置起多少个slave，建议根据CPU核数设置
SLAVE_COUNT=8

#配置MASTER
MASTER_HOST="127.0.0.1"

for((i=1;i<=$SLAVE_COUNT;i++))
do
	docker run \
    -v $WORKDIR/locustfile:/software/locust/locustfile \ 
    -e LOCUST_MODE=slave \
    -e MASTER_HOST=$MASTER_HOST \
    -e SCENARIO_FILE=/software/locust/locustfile/locustfile.py \
    --name $CONTAINER_NAME \
    easy_locust:v1
done


