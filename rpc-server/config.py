servers = [{
  'id': 1,
  'secret_key': "MDACBsrfnElnEGzL",
  'port': 3401,
  'env': "localhost",
  'name': "Virginia-West",
}, {
  'id': 2,
  'secret_key': "zQhufNiR9iDXlyQU",
  'port': 3402,
  'env': "localhost",
  'name': "US-East",
}]

clients = [{
  'id': 1,
  'secret_key': 'iWFpB2vs1dSxghIO',
  'username': 'alwayswannaly',
  'password': 'password',
}, {
  'id': 2,
  'secret_key': 'j2xnsBUI2q66UQ3r',
  'username': 'neverwannafly',
  'password': 'password',
}, {
  'id': 3,
  'secret_key': 'heTeRtn3lh0dRA1h',
  'username': 'vishal',
  'password': 'password',
}, {
  'id': 4,
  'secret_key': 's6MozPLiid8MCecc',
  'username': 'raze',
  'password': 'password',
}, {
  'id': 5,
  'secret_key': 'xyYdrKFJnoGOkv2X',
  'username': 'jett',
  'password': 'password',
}]

kdc = {
  'id': 1,
  'secret_key': 'xLWDSEcrhElRpWjX',
  'port': 3400,
  'env': 'localhost',
}

balancer = {
  'id': 1,
  'secret_key': 'weHgSPoiUy6WgSk0',
  'port': 3100,
  'env': 'localhost',
  'name': 'load-balancer'
}

config = {
  'kdc': kdc,
  'clients': clients,
  'servers': servers,
  'balancers': balancer,
}