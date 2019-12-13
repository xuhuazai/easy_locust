### 
# @Author: your name
 # @Date: 2019-12-13 14:25:15
 # @LastEditTime: 2019-12-13 15:24:11
 # @LastEditors: Please set LastEditors
 # @Description: In User Settings Edit
 # @FilePath: \easy_locust\locust-master.sh
 ###
#!/bin/bash

WORKDIR=$(dirname $0)
CONTAINER_NAME="easy_locust"

function RemoveContainer {
	docker stop $1 && docker rm $1
}

RemoveContainer $CONTAINER_NAME

#配置测试的目标URL
TARGET_URL="http://10.95.147.103:8080"

docker run
    -v $WORKDIR/locustfile:/software/locust/locustfile \ 
    -e LOCUST_MODE=master \
    -e SCENARIO_FILE=/software/locust/locustfile/locustfile.py \
    -e TARGET_URL=$TARGET_URL \
    -p 5557:5557 \
    -p 5558:5558 \
    -p 8089:8089 \
    --name $CONTAINER_NAME \
    easy_locust:v1