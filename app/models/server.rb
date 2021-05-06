class Server < ApplicationRecord
  enum status: [:active, :inactive, :deleted]
  enum state: [:up, :down]
  enum server_type: [:file, :kdc, :balancer]

  def url
    "http://#{self.host}:#{self.port}"
  end
end
