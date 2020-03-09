#!/bin/bash

WORKDIR=$(cd "$(dirname "$0")";pwd)
CONTAINER_NAME="easy_locust_slave"


docker stop $(docker ps -a | awk '/easy_locust_slave/ {print $1}')
docker rm  $(docker ps -a | awk '/easy_locust_slave/ {print $1}')

#设置起多少个slave，建议根据CPU核数设置。该参数支持命令行传入，默认为1
SLAVE_COUNT=${1:-1}

#配置MASTER-注意：由于每个slave都是一个独立的docker运行，所以这里千万不能配置127.0.0.1
MASTER_HOST="10.95.147.122"

for((i=1;i<=$SLAVE_COUNT;i++))
do
	docker run \
	    -v $WORKDIR/locustfile:/software/locust/locustfile \
	    -v $WORKDIR/fix_geventhttpclient_upload_py/useragent.py:/usr/local/lib/python3.6/dist-packages/geventhttpclient/useragent.py \
    	-v $WORKDIR/fix_geventhttpclient_upload_py/fasthttp.py:/usr/local/lib/python3.6/dist-packages/locust/contrib/fasthttp.py \
	    -e LOCUST_MODE=slave \
	    -e MASTER_HOST=$MASTER_HOST \
	    -e SCENARIO_FILE=/software/locust/locustfile/locustfile.py \
	    --name $CONTAINER_NAME"_"$i \
	    easy_locust:v1 &
done


