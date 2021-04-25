from xmlrpc.server import SimpleXMLRPCServer
from xmlrpc.server import SimpleXMLRPCRequestHandler
from random import choice

import config
from colors import bcolors
from base.Server import LoadBalancer

# Initialize Servers
servers = config.servers
BALANCER = LoadBalancer(config.balancer)

# Restrict to a particular path.
class RequestHandler(SimpleXMLRPCRequestHandler):
  rpc_paths = ('/RPC2',)

# Create server
with SimpleXMLRPCServer((BALANCER.env, BALANCER.port), requestHandler=RequestHandler) as server:
  server.register_introspection_functions()

  def request_server():
    selected_server = choice(servers)
    print(f"{bcolors.OKCYAN}Redirected to [{selected_server['name']}@{selected_server['env']}:{selected_server['port']}]{bcolors.CEND}")
    return selected_server['id']

  # Registrations
  server.register_function(request_server, 'request_server')

  print(f"{bcolors.OKGREEN}Started server {BALANCER}{bcolors.CEND}")

  server.serve_forever()
