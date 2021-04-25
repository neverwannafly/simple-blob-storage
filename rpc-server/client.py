from getpass import getpass
import xmlrpc.client

import config
from colors import bcolors

# Authenticate User
print(f"{bcolors.OKBLUE}Please login to create session{bcolors.CEND}")
user_session = {}

def try_establish_session():
  username = input(">> Username: ")
  password = getpass()

  clients = config.clients
  # Match client
  result = list(filter(lambda client: client['username']==username and client['password']==password, clients))

  if len(result) == 0:
    print(f"{bcolors.FAIL}>> Invalid Credentials! Please try again{bcolors.CEND}")
    try_establish_session()
  else:
    global user_session
    user_session = result[0].copy()

try_establish_session()

# Request server from load balancer

balancer_config = config.balancer
balancer = xmlrpc.client.ServerProxy(f"http://{balancer_config['env']}:{balancer_config['port']}")

available_server_id = balancer.request_server()

kdc_config = config.kdc
kdc = xmlrpc.client.ServerProxy(f"http://{kdc_config['env']}:{kdc_config['port']}")

def get_command_list(remote):
  return {
    "ls": remote.ls,
    "pwd": remote.pwd,
    "cp": remote.cp,
    "cat": remote.cat,
    "touch": remote.touch,
  }

# Setup session with file server

try:
  session = kdc.create_session(user_session['id'], available_server_id)
  if session:
    remote_server = xmlrpc.client.ServerProxy(session['address'])
    server_msg = remote_server.ping()
    commands = get_command_list(remote_server)
    while True:
      command = input(f"{bcolors.OKGREEN}{server_msg} >> {bcolors.CEND}")
      command_as_list = command.split(' ')
      main_command = command_as_list[0]
      if main_command == "help":
        print(f"{bcolors.WARNING}")
        print("|------------------------------|")
        print("| 1. ls: list files            |")
        print("| 2. pwd: present directory    |")
        print("| 3. touch: create file        |")
        print("| 4. cp: copy files            |")
        print("| 5. cat: show file content    |")
        print("| 6. exit: close connection    |")
        print("|------------------------------|")
        print(f"{bcolors.CEND}")
      elif main_command == "exit":
        print(f"{bcolors.FAIL}{kdc.destroy_session(user_session['id'], available_server_id)}{bcolors.CEND}")
        exit()
      elif (main_command in commands):
        def safe_access(i):
          return command_as_list[i] if i < len(command_as_list) else False

        response = commands[main_command]({
          'client_id': user_session['id'],
          'c1': safe_access(1),
          'c2': ' '.join(command_as_list[2:]),
        })
        print(f'{bcolors.OKBLUE}{response}{bcolors.CEND}')
      else:
        print(f"{bcolors.WARNING}>> Invalid command. Type `help` to get list of commands{bcolors.CEND}")
  else:
    print(f"{bcolors.FAIL}>> Authentication Failed!{bcolors.CEND}")
    exit()
except KeyboardInterrupt:
  print()
  print(f"{bcolors.FAIL}{kdc.destroy_session(user_session['id'], available_server_id)}{bcolors.CEND}")
