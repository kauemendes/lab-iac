from locust import FastHttpUser, task

class WebsiteUser(FastHttpUser):
  
  host = "http://0.0.0.0:8089"  

  @task
  def index(self):
      self.client.get("/")