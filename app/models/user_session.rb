class UserSession < ApplicationRecord
  enum state: [:ongoing, :ended ]

  def self.find_or_create(user, auth_token)

  end
end
