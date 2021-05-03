class UserSession < ApplicationRecord
  enum state: [:ongoing, :ended ]
end
