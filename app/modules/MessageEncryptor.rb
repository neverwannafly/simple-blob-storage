module MessageEncryptor
  def random_string(len = 32)
    SecureRandom.hex(len)
  end

  def encrypt(text)
    text = text.to_s unless text.is_a? String
  
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = random_string(len)
    key   = ActiveSupport::KeyGenerator.new(password).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    encrypted_data = crypt.encrypt_and_sign(text)
    "#{salt}#{seperator_pattern}#{encrypted_data}"
  end
  
  def decrypt(text)
    salt, data = text.split(seperator_pattern)
  
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(password).generate_key(salt, len)
    crypt = ActiveSupport::MessageEncryptor.new(key)
    crypt.decrypt_and_verify(data)
  end

  private

  def seperator_pattern
    "(~&*$#%@)"
  end

  def password
    ENV.fetch('MESSAGE_ENCRYPTOR_SECRET')
  end
end
