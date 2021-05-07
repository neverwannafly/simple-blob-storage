import sys
import subprocess
from xmlrpc.server import SimpleXMLRPCServer
from xmlrpc.server import SimpleXMLRPCRequestHandler

import config
from colors import bcolors
from base.Server import FileServer, LoadBalancer

if len(sys.argv) != 2:
  print("Please provide server id")
  exit()

server_id = sys.argv[1]
server_configs = list(filter(lambda server: server['id'] == server_id, config.servers))

def get_client(client_id):
  return list(filter(lambda client: client['id'] == client_id, config.clients))[0]

if len(server_configs) == 0:
  print("Invalid server id")
  exit()

SERVER = FileServer(server_configs[0])
ENV = SERVER.env
PORT = SERVER.port

class RequestHandler(SimpleXMLRPCRequestHandler):
  rpc_paths = ('/RPC2',)

with SimpleXMLRPCServer((ENV, PORT), requestHandler=RequestHandler) as server:
  def ping():
    return f"{SERVER}"

  def ls(args):
    print(args)
    client = get_client(args['client_id'])
    current_path = SERVER.client_path(client['username'])
    res = subprocess.run(['ls', current_path], stdout=subprocess.PIPE)
    return res.stdout.decode('utf-8')

  def pwd(args):
    client = get_client(args['client_id'])
    current_path = SERVER.client_path(client['username'], relative=True)
    return current_path

  def touch(args):
    client = get_client(args['client_id'])
    current_path = SERVER.client_path(client['username'])
    file_name = args['c1']
    content = args['c2']
    if file_name is False or file_name is "":
      return "Please enter filename"
    subprocess.run(['touch', f'{current_path}/{file_name}'], stdout=subprocess.PIPE)
    if content is not False or content is "":
      f = open(f'{current_path}/{file_name}', "w")
      f.write(content)
      f.close()
    return f"File created"

  def cat(args):
    client = get_client(args['client_id'])
    current_path = SERVER.client_path(client['username'])
    file_name = args['c1']
    if file_name is False or file_name is '':
      return "Please enter filename"
    res = subprocess.run(['cat', f'{current_path}/{file_name}'], stdout=subprocess.PIPE)
    return res.stdout.decode('utf-8')

  def cp(args):
    client = get_client(args['client_id'])
    current_path = SERVER.client_path(client['username'])
    file1_name = args['c1']
    file2_name = args['c2']
    if file1_name is False or file2_name == '' or file1_name == '' or file2_name is False:
      return "Please enter both filenames"
    res = res = subprocess.run([
      'cp',
      f'{current_path}/{file1_name}',
      f'{current_path}/{file2_name}'
    ], stdout=subprocess.PIPE)
    return "Copied contents!"

  def add_connection(client_username):
    SERVER.add_connection(client_username)
    res = subprocess.run(['ls', 'db'], stdout=subprocess.PIPE)
    if res.stdout.decode('utf-8').find(client_username) == -1:
      subprocess.run(['mkdir', SERVER.client_path(client_username)])
    return f"Client::{client_username} connected to {SERVER}! Active connections={len(SERVER.connections)}"

  def remove_connection(client_username):
    SERVER.remove_connection(client_username)
    return f"Client::{client_username} disconnected from {SERVER}! Active connections={len(SERVER.connections)}"

  server.register_function(ping, 'ping')
  server.register_function(add_connection, 'add_connection')
  server.register_function(remove_connection, 'remove_connection')
  server.register_function(touch, 'touch')
  server.register_function(ls, 'ls')
  server.register_function(pwd, 'pwd')
  server.register_function(cat, 'cat')
  server.register_function(cp, 'cp')

  print(f"{bcolors.OKGREEN}Started server {SERVER}{bcolors.CEND}")
  server.serve_forever()