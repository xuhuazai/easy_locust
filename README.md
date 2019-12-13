# easy_locust
基于docker非常容易部署使用的locust分布式版本，使用geventhttpclient库，压力机性能至少提升一倍！

## 使用说明
### 准备工作
请先在机器上安装docker运行环境，可参考[docker官方](https://docs.docker.com/install/ "docker官方")
### 拉取代码
docker安装好后，将代码拉到本地，执行`git clone https://github.com/xuhuazai/easy_locust.git`
### 目录结构说明
    ├── build-docker-image.sh `构建docker镜像的脚本`
    ├── Dockerfile
    ├── LICENSE
    ├── locustfile
    │   └── locustfile.py `locust性能测试脚本，在此脚本里编写你想要测试的接口`
    ├── locust-master.sh  `当前服务器为locust master模式时，执行该脚本`
    ├── locust-slave.sh   `当前服务器为locust slave模式时，执行该脚本，在该脚本中配置master、启动几个slave`
    ├── locust-standalone.sh  `当前服务器为locust standalone模式时，执行该脚本`
    ├── README.md
    └── run.sh `该文件会拷贝到easy_locust镜像里，负责调用locust可执行程序`
### 配置Locust
#### 编写locust脚本
    vi locustfile\locustfile.py
    
    from locust import TaskSet, task, between
    from locust.contrib.fasthttp import FastHttpLocust
    
    class WebsiteTasks(TaskSet):
        
        def on_start(self):
            pass
    
        def on_stop(self):
            pass
    
        @task
        def lua(self):
            r = self.client.get('/lua')
            with self.client.get('/lua', catch_response = True) as response:
                if response.status_code == 200:
                    response.success()
                else:
                    response.failure('Failed!')
    
    class WebsiteUser(FastHttpLocust):
        task_set = WebsiteTasks
        wait_time = between(5, 15)
        host = '10.95.147.103:8080'
    
#### 运行locust
easy_locust支持三种模式运行，分别为：


`standalone`[单机运行模式-简单性能测试时使用，只用一台压力机即可]


`master`[master模式-该模式不产生实际压力，所以需要启动最少一台salve]


`slave`[slave模式-salve可以与master放在一台机器上，也可以分布式部署，配置`MASTER_HOST`即可]。



了解这三种模式后，你要根据实际的情况来选择，如果实际场景为`master`或`standalone`时，直接运行对应的`locust-$mode.sh`脚本即可，但是为`slave`模式时需要进行一些配置
    
    vi locust-slave.sh
	
    #设置起多少个slave，建议根据CPU核数设置。该参数支持命令行传入，默认为1
    SLAVE_COUNT=8
    
    #配置MASTER-注意：由于每个slave都是一个独立的docker运行，所以这里千万不能配置127.0.0.1
    MASTER_HOST="10.95.147.122"


感谢你的使用，如果有任何问题，可以在线提交Issues！
