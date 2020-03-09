from locust import TaskSet, task, between
from locust.contrib.fasthttp import FastHttpLocust
from urllib3 import encode_multipart_formdata

#import requests

class WebsiteTasks(TaskSet):
    
    def on_start(self):
        pass

    def on_stop(self):
        pass

    @task
    def lua(self):
         #headers={'Content-Type':'multipart/form-data', 'Content-Encoding':'gzip', 'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.92 Safari/537.36'}
        files={'file': ("gwlog.zip", open('/software/locust/locustfile/gwlog.zip','rb').read(), "application/zip")}
        d = encode_multipart_formdata(files, boundary='eaaee54a-3b9a-4b60-9d98-0b5f27d9c4ef')
        with self.client.post('/api/uploadlog.json', data=d[0], headers = {"content-type": d[1]}) as response:
            if response.status_code == 200:
                response.success()
            else:	
                print(response.text)

class WebsiteUser(FastHttpLocust):
    task_set = WebsiteTasks
    wait_time = between(5, 15)
    host = 'http://10.95.147.115:9502'
