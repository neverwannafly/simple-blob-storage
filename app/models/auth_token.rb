class AuthToken < ApplicationRecord
  belongs_to :bearer, polymorphic: true
  encrypts :token, deterministic: true

  enum status: [:active, :inactive]
  enum scope: [:read_only, :write_only, :read_and_write]

  def self.authenticate(token, scope: :read_and_write)
    return self.where(token: token, scope: scope).first.present?
  end
end
