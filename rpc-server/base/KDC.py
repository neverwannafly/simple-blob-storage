class KeyDistributionCenter:
  def __init__(self, config):
    self.secret_key = config['kdc']['secret_key']
    self.port = int(config['kdc']['port'])
    self.env = config['kdc']['host']
    self.client_keys = self.set_keys(config['servers'])
    self.server_keys = self.set_keys(config['clients'])
    self.session_keys = []

  def set_keys(self, entity):
    keys = []
    for obj in entity:
      keys.append({
        'id': obj['id'],
        'key': obj['secret_key'],
      })
    return keys

  def get_key(self, entity_id, entity_type):
    if entity_type == 'server':
      entity = self.server_keys
    else:
      entity = self.client_keys

    res = list(filter(lambda instance: instance['id'] == entity_id, entity))

    return -1 if len(res) == 0 else res[0]['key']

  def generate_session_key(self, client_id, server_id):
    client_key = self.get_key('client', client_id)
    server_key = self.get_key('server', server_key)

  def __str__(self):
    return f"[KeyDistributionServer@{self.env}:{self.port}]"

  def __repr__(self):
    return f"[KeyDistributionServer@{self.env}:{self.port}]"

  