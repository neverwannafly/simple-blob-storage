from xmlrpc.server import SimpleXMLRPCServer
from xmlrpc.server import SimpleXMLRPCRequestHandler

import config
from colors import bcolors
from base.KDC import KeyDistributionCenter
from base.Server import FileServer, LoadBalancer
from lib.AES import decrypt, encrypt

def get_client(client_id):
  return list(filter(lambda client: client['id'] == client_id, config.clients))[0]

# Initialize Servers
servers = config.servers
SERVERS = {}
for server in servers:
  SERVERS[server['id']] = FileServer(server, proxy=True)

KDC = KeyDistributionCenter(config.config)
ENV = KDC.env
PORT = KDC.port

class RequestHandler(SimpleXMLRPCRequestHandler):
  rpc_paths = ('/RPC2',)

with SimpleXMLRPCServer((ENV, PORT), requestHandler=RequestHandler) as server:
  server.register_introspection_functions()

  def create_session(client_id, server_id):
    client = get_client(client_id)
    print(f"{bcolors.OKCYAN}{SERVERS[server_id].proxy.add_connection(client['username'])}{bcolors.CEND}")
    return {
      'address': f"http://{SERVERS[server_id].address()}",
    }

  def destroy_session(client_id, server_id):
    client = get_client(client_id)
    print(f"{bcolors.OKCYAN}{SERVERS[server_id].proxy.remove_connection(client['username'])}{bcolors.CEND}")
    return f"Disconnected from {SERVERS[server_id]}"

  server.register_function(create_session, 'create_session')
  server.register_function(destroy_session, 'destroy_session')

  print(f"{bcolors.OKGREEN}Started server {KDC}{bcolors.CEND}")
  server.serve_forever()