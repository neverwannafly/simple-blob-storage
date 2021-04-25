import xmlrpc

class BaseServer:
  def __init__(self, config):
    self.id = config['id']
    self.name = config['name']
    self.port = config['port']
    self.env = config['env']
    self.secret_key = config['secret_key']

  def getId(self):
    return self.id

  def address(self):
    return f"{self.env}:{self.port}"

  def __str__(self):
    return f"[{self.name}@{self.address()}]"

  def __repr__(self):
    return f"[{self.name}@{self.address()}]"

class FileServer(BaseServer):
  def __init__(self, config, proxy = False):
    super().__init__(config)
    self.connections = set()
    if proxy:
      self.proxy = xmlrpc.client.ServerProxy(f"http://{self.env}:{self.port}")

  def add_connection(self, client_username):
    self.connections.add(client_username)
    print(f"\033[92m>> Client::{client_username} connected\033[0m")

  def remove_connection(self, client_username):
    self.connections.discard(client_username)
    print(f"\033[91m>> Client::{client_username} disconnected\033[0m")

  def client_path(self, client_username):
    return f'db/{client_username}'

class LoadBalancer(BaseServer):
  def __init__(self, config):
    super().__init__(config)