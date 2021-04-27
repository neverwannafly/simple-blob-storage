class AuthToken < ApplicationRecord
  belongs_to :bearer, polymorphic: true
end
