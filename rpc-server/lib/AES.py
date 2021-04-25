from Crypto.Cipher import AES

def encrypt(secret_key, plaintext):
  cipher = AES.new(secret_key, AES.MODE_EAX)
  nonce = cipher.nonce
  ciphertext, tag = cipher.encrypt_and_digest(plaintext)
  return { 'ciphertext': ciphertext, 'nonce': nonce, 'tag': tag }

def decrypt(secret_key, data):
  cipher = AES.new(secret_key, AES.MODE_EAX, nonce=data['nonce'])
  plaintext = cipher.decrypt(data['ciphertext'])
  try:
    cipher.verify(data['tag'])
    return (True, plaintext)
  except ValueError:
    return (False, None)