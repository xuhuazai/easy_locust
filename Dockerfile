FROM ubuntu:latest

LABEL MAINTAINER="Xushaohua xushaohua@159n.com"

RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.163.com/@g /etc/apt/sources.list

RUN apt-get update \
    && apt-get install -y python3-dev python3-zmq python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /software/locust

RUN pip3 install -i http://pypi.douban.com/simple --trusted-host pypi.douban.com locustio==0.14.6 psutil geventhttpclient-wheels==1.3.1.dev2

ADD run.sh /usr/local/bin/run.sh
RUN chmod 0755 /usr/local/bin/run.sh \
    && ulimit -c -m -s -t unlimited

EXPOSE 8089 5557 5558

CMD ["/usr/local/bin/run.sh"]
