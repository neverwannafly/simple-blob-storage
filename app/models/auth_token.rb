class AuthToken < ApplicationRecord
  extend MessageEncryptor
  belongs_to :bearer, polymorphic: true

  enum status: [:active, :inactive]
  enum scope: [:read_only, :write_only, :read_and_write]

  def self.get_tokens_for_bearer(bearer)
    tokens = []
    self.where(bearer: bearer).order("id desc").map do |auth_token|
      tokens << {
        name: auth_token.name,
        scope: auth_token.scope,
        token: self.decrypt(auth_token.token)[0,8] + '*' * 24
      }
    end
    tokens
  end

  def self.authenticate(token, bearer, scope, name)
    auth_token = self.active.where(scope: scope, bearer: bearer, name: name).first
    return false unless auth_token.present?

    self.encrypt(token) == auth_token.token
  end

  def self.get_decrypted_token(bearer, scope, name)
    auth = self.where(bearer: bearer, scope: scope, name: name).first
    return nil if auth.nil?

    self.decrypt(auth.token)
  end

  def self.is_present?(bearer, scope, name)
    self.active.where(bearer: bearer, scope: scope, name: name).first.present?
  end
end
