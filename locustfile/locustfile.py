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
    wait_time = between(0, 0)
    host = 'http://192.168.0.4:80'
