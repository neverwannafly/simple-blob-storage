from MySQLdb import _mysql

db = _mysql.connect(
  user ='root',
  passwd = '10p17fs0008',
  host = 'localhost',
  db = 'rpc_file_system_development'
)

db.query("SELECT * from servers")

query_output = db.store_result()
res = query_output.fetch_row(0, 1)
for row in res:
  for key in row:
    row[key] = row[key].decode('utf-8')

servers = list(filter(lambda server: server['server_type'] == '0', res))
kdc = list(filter(lambda server: server['server_type'] == '1', res))[0]
balancer = list(filter(lambda server: server['server_type'] == '2', res))[0]

db.query("SELECT id, username, 'password' as password, '' as secret_key from users")

query_output = db.store_result()
res = query_output.fetch_row(0, 1)
for row in res:
  for key in row:
    row[key] = row[key].decode('utf-8')
    if key == 'id':
      row[key] = int(row[key])

clients = res
# clients = [{
#   'id': 1,
#   'secret_key': 'iWFpB2vs1dSxghIO',
#   'username': 'alwayswannaly',
#   'password': 'password',
# }, {
#   'id': 2,
#   'secret_key': 'j2xnsBUI2q66UQ3r',
#   'username': 'neverwannafly',
#   'password': 'password',
# }, {
#   'id': 3,
#   'secret_key': 'heTeRtn3lh0dRA1h',
#   'username': 'vishal',
#   'password': 'password',
# }, {
#   'id': 4,
#   'secret_key': 's6MozPLiid8MCecc',
#   'username': 'raze',
#   'password': 'password',
# }, {
#   'id': 5,
#   'secret_key': 'xyYdrKFJnoGOkv2X',
#   'username': 'jett',
#   'password': 'password',
# }]

config = {
  'kdc': kdc,
  'clients': clients,
  'servers': servers,
  'balancers': balancer,
}