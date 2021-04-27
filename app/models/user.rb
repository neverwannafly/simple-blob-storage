class User < ApplicationRecord
  t.text :username, unique: true, index: true
  t.text :email, unique: true, index: true,
  t.text :first_name,
  t.text :last_name,
end
